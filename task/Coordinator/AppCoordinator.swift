//  task
//
//  Created by islam on 9/23/20.
//

import UIKit
import RxSwift
import CoreData

final class AppCoordinator: Coordinator<Void> {
    
    private let navigationController:UINavigationController
    private let window: UIWindow
    let dependencies: AppDependency
    
    init(window:UIWindow, navigationController:UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        self.dependencies = AppDependency(window: self.window, managedContext: Application.managedObjectContext)
    }
    
    override func start() -> Observable<Void> {
        // Show Movie list screen
        return showCategoriesList()
    }
    
    private func showCategoriesList() -> Observable<Void> {
        let rootCoordinator = RootCoordinator(navigationController: navigationController, dependencies: self.dependencies)
        return coordinate(to: rootCoordinator)
    }
    
    
    deinit {
        plog(AppCoordinator.self)
    }
    
}

class RootCoordinator: Coordinator<Void>{
    typealias Dependencies = HasWindow & HasAPI & HasCoreData
    
    private let rootNavigationController:UINavigationController
    private let dependencies: Dependencies
    
    init(navigationController:UINavigationController, dependencies: Dependencies) {
        self.rootNavigationController = navigationController
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<CoordinationResult> {
        let viewModel = CategoryListViewModel.init(dependencies: self.dependencies)
        let viewController = UIStoryboard.main.categoriesListViewController
        viewController.viewModel = viewModel
        
        viewModel.selectedCategory.asObservable().subscribe(onNext: {[weak self] category in
            guard let `self` = self else {return}
            guard let _category = category else {return}
            self.pushToProducts(category: _category)
        }).disposed(by: disposeBag)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        dependencies.window.rootViewController = rootNavigationController
        dependencies.window.makeKeyAndVisible()
        return Observable.never()
    }
    
    
    func pushToProducts(category : Category) {
        let productsListCoodinator = ProductsListCoodinator(navigationController: rootNavigationController, dependencies: self.dependencies, category: category)
       _ = self.coordinate(to: productsListCoodinator)
    }
    
    deinit {
        plog(RootCoordinator.self)
    }
}

protocol PresentProductDetails {
    func presentPopup(product : Product)
}
