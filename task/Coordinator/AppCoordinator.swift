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
        return showMovieList()
    }
    
    private func showMovieList() -> Observable<Void> {
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
        let viewModel = MoviesListViewModel.init(dependencies: self.dependencies)
        let viewController = UIStoryboard.main.moviesListViewController
        viewController.viewModel = viewModel
        
        viewModel.selectedMovie.asObservable().subscribe(onNext: {[weak self] movie in
            guard let `self` = self else {return}
            guard let _movie = movie else {return}
            self.pushToMovieDetails(selectedMovie: _movie)
        }).disposed(by: disposeBag)
        
        rootNavigationController.pushViewController(viewController, animated: true)
        dependencies.window.rootViewController = rootNavigationController
        dependencies.window.makeKeyAndVisible()
        return Observable.never()
    }
    
    func pushToMovieDetails(selectedMovie: Movie) {
        let viewModel = MovieDetailViewModel.init(dependencies: self.dependencies, movie: selectedMovie)
        let viewController = UIStoryboard.main.movieDetailsViewController
        viewController.viewModel = viewModel
        
        viewModel.popToMovieList
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.rootNavigationController.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        rootNavigationController.pushViewController(viewController, animated: true)
    }
    
    deinit {
        plog(RootCoordinator.self)
    }
}
