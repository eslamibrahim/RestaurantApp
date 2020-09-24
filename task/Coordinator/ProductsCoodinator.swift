//
//  ProductsListCoodinator.swift
//  task
//
//  Created by islam on 9/24/20.
//

import RxSwift
import UIKit
import PopupDialog

class ProductsListCoodinator: Coordinator<Void> {
    
    private let navigationController: UINavigationController
    private let dependencies:Dependencies
    let category : Category
    init(navigationController: UINavigationController ,dependencies:Dependencies,category : Category ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.category = category
    }
    
    override func start() -> Observable<Void> {
        let viewController = UIStoryboard.main.productsViewController
        let viewModel = ProductsViewModel(dependencies: self.dependencies, category: self.category)
        viewModel.selectedProduct.asObservable().subscribe(onNext: { item in
            guard let _item = item else {return}
            self.presentProductDetails(product: _item)
        }).disposed(by: disposeBag)

        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
        return Observable.empty()
    }
    
    func presentProductDetails (product : Product){
        self.navigationController.popViewController(animated: true)
        let viewController = UIStoryboard.main.productDetailsPopUpViewController
        viewController.product = product
        let popUpView = PopupDialog(viewController: viewController)
        self.navigationController.present(popUpView, animated: true, completion: nil)
    }
    deinit {
        plog(ProductsListCoodinator.self)
    }
}
