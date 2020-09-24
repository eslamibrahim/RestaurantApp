//
//  CategoryListViewModel.swift
//  task
//
//  Created by islam on 9/24/20.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import CoreData


typealias Dependencies = HasAPI & HasCoreData

class CategoryListViewModel: BaseViewModel {
    
    // Dependencies
    private let dependencies: Dependencies
    var managedObjectContext: NSManagedObjectContext!
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    //API Result
    var getCategoriessData: Observable<APIResult<GetCategoryResponse>> {
        return _getCategoriesData.asObservable().observeOn(MainScheduler.instance)
    }
    private let _getCategoriesData = ReplaySubject<APIResult<GetCategoryResponse>>.create(bufferSize: 1)
    
    //Data
    var categoriesTableData: Observable<[Category]>
    var categories: BehaviorRelay<[Category]> = BehaviorRelay(value: [])
    
    
    var categoriesPerPage : BehaviorRelay<[Category]> = BehaviorRelay(value: [])
    var lastPage : Bool {
        if !isFromCoredata{
            if currentPage < totalPages {
                return false
            }
            else {
                return true
            }
        }
        else{
            return true
        }
    }
    var totalPages : Int  {
        let x = totalCategoryNumber / 20
        let y = totalCategoryNumber % 20
        return x + y
    }
    var currentPage = 0
    var totalCategoryNumber = 0

    
    //Paging Metadata
    var nextPage: Int? = 1
    var isFromCoredata: Bool = false

    //Method
    var callNextPage = PublishSubject<Void>()
    let selectedCategory = PublishSubject<Category?>()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.categoriesTableData = categoriesPerPage.asObservable()
        self.managedObjectContext = dependencies.managedObjectContext
        super.init()
        
        self.callNextPage.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            // Check internet availability, call next page API if internet available
            if NetworkReachabilityManager()!.isReachable == true {
                if self.nextPage != nil {
                    self.getCategories(nextPage: self.nextPage!)
                }
            } else {
                // Fetch movie data from local cache, as internet is not available
                self.getCategoriesFromCoreData()
            }
        }).disposed(by: disposeBag)
        
        getCategoriessData
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    if response.data != nil {
                        self.totalCategoryNumber = response.meta?.total ?? 0
                        for category in response.data! {
                            _ = try? self.managedObjectContext.rx.update(CategoryCoreData.init(category: category))
                        }
                        self.categories.accept(response.data! +  self.categories.value)
                        if !self.lastPage{
                        let array = self.categories.value[(self.currentPage*20)..<((self.currentPage + 1)*20)]
                            self.categoriesPerPage.accept(Array(array))
                        }
                        
                    }
                    self.nextPage = response.nextPage
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
        
}

//MARK:- Core Data
extension CategoryListViewModel {
    
    func getCategoriesFromCoreData() {
        
        isFromCoredata = true
        managedObjectContext.rx.entities(CategoryCoreData.self, sortDescriptors: []).asObservable()
            .subscribe(onNext: { [weak self] _categories in
                guard let `self` = self else {return}
                
                // Check local cache record count and binded array count same, no need to execute further code
                if self.categories.value.count == _categories.count {
                    return
                }
                var categories = [Category]()
                for category in _categories {
                    let movieModel = Category.init(category: category)
                    // Check movie object is contains in main array which bind to tableview, ignore that object
                    if self.categories.value.contains(where: { $0.id == movieModel.id }) == false {
                        categories.append(Category.init(category: category))
                    }
                }
                self.categories.accept(categories + self.categories.value)
                self.nextPage = (self.categories.value.count/50)+1
                if (_categories.count % 20) >= 0 {
                    let array = self.categories.value[(self.currentPage*20)..<((self.currentPage + 1)*20)]
                    self.categoriesPerPage.accept(Array(array))
                }

            }).disposed(by: disposeBag)
    }
}

//MARK:- API Call
extension CategoryListViewModel {

    func getCategories(nextPage: Int = 1) {
        let parameter = [
            Params.page.rawValue : nextPage
            ] as [String : Any]
        
        dependencies.api.getCategoriesDetails(param: parameter)
            .trackActivity(nextPage == 1 ? isLoading : ActivityIndicator())
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let _):
                        self._getCategoriesData.on(event)
                    case .failure(let error):
                        // Fetch data from local cache when internet is not available
                        if error.code == InternetConnectionErrorCode.offline.rawValue {
                            self.getCategoriesFromCoreData()
                            self.alertDialog.onNext((NSLocalizedString("Network error", comment: ""), error.message))
                        } else {
                            self.alertDialog.onNext(("Error", error.message))
                        }
                    }
                    
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
}
