//
//  task
//
//  Created by islam on 9/23/20.
//
import Foundation
import UIKit

extension UIStoryboard {

    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }

}


extension UIStoryboard {
    
    var moviesListViewController: MoviesListViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: MoviesListViewController.self)) as? MoviesListViewController else {
            fatalError(String(describing: MoviesListViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
    var movieDetailsViewController: MovieDetailsViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: MovieDetailsViewController.self)) as? MovieDetailsViewController else {
            fatalError(String(describing: MovieDetailsViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
}
