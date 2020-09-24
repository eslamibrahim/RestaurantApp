//
//  ProductsViewModel.swift
//  task
//
//  Created by islam on 9/24/20.
//


import Alamofire
import RxSwift
import RxCocoa
import CoreData


class ProductsViewModel: BaseViewModel {
    
    // Dependencies
    private let dependencies: Dependencies
    var managedObjectContext: NSManagedObjectContext!
    
    /// Network request in progress
    let isLoading: ActivityIndicator =  ActivityIndicator()
    
    //API Result
    var getProductsData: Observable<APIResult<GetProductResponse>> {
        return _getProductsData.asObservable().observeOn(MainScheduler.instance)
    }
    private let _getProductsData = ReplaySubject<APIResult<GetProductResponse>>.create(bufferSize: 1)
    
    //Data
    var productsTableData: Observable<[Product]>
    var products: BehaviorRelay<[Product]> = BehaviorRelay(value: [])
    
    //Paging Metadata
    var nextPage: Int? = 1
    var isFromCoredata: Bool = false

    //Method
    var callNextPage = PublishSubject<Void>()
    let selectedProduct = PublishSubject<Product?>()
    let category : Category
    init(dependencies: Dependencies , category : Category) {
        self.dependencies = dependencies
        self.productsTableData = products.asObservable()
        self.managedObjectContext = dependencies.managedObjectContext
        self.category = category
        super.init()
        
        self.callNextPage.asObservable().subscribe(onNext: { [weak self] in
            guard let `self` = self else { return }
            // Check internet availability, call next page API if internet available
            if NetworkReachabilityManager()!.isReachable == true {
                if self.nextPage != nil {
                    self.getProducts(nextPage: self.nextPage!)
                }
            } else {
                // Fetch movie data from local cache, as internet is not available
                self.getProductsFromCoreData()
            }
        }).disposed(by: disposeBag)
        
        getProductsData
            .subscribe(onNext: { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(let response):
                    if response.data != nil {
                        for product in response.data! {
                            _ = try? self.managedObjectContext.rx.update(ProductCoreDateModel.init(product: product))
                        }
                        let _products = response.data!.filter { [weak self] (product) in
                            product.category?.id == category.id
                        }
                        self.products.accept(_products +  self.products.value)
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
extension ProductsViewModel {
    
    func getProductsFromCoreData() {

        isFromCoredata = true
        managedObjectContext.rx.entities(ProductCoreDateModel.self, sortDescriptors: []).asObservable()
            .subscribe(onNext: { [weak self] _products in
                guard let `self` = self else {return}

                // Check local cache record count and binded array count same, no need to execute further code
                if self.products.value.count == _products.count {
                    return
                }
                var products = [Product]()
                for product in _products {
                    let productModel = Product.init(product: product)
                    // Check movie object is contains in main array which bind to tableview, ignore that object
                    if self.products.value.contains(where: { $0.id == productModel.id }) == false {
                        products.append(Product.init(product: product))
                    }
                }
                let _products = products.filter { [weak self] (product) in
                    product.category?.id == self?.category.id
                }
                self.products.accept(_products +  self.products.value)
                self.nextPage = (self.products.value.count/50)+1
            }).disposed(by: disposeBag)
    }
}

//MARK:- API Call
extension ProductsViewModel {

    func getProducts(nextPage: Int = 1) {
        let parameter = [Params.include.rawValue : "category",
                         Params.page.rawValue : nextPage
        ] as [String : Any]
        
        dependencies.api.getProducts(param: parameter)
            .trackActivity(nextPage == 1 ? isLoading : ActivityIndicator())
            .observeOn(SerialDispatchQueueScheduler(qos: .default))
            .subscribe {[weak self] (event) in
                guard let `self` = self else { return }
                switch event {
                case .next(let result):
                    switch result {
                    case .success(let _):
                        self._getProductsData.on(event)
                    case .failure(let error):
                        // Fetch data from local cache when internet is not available
                        if error.code == InternetConnectionErrorCode.offline.rawValue {
                            self.getProductsFromCoreData()
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
