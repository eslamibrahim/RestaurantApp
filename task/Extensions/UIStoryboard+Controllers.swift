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
    
    
    var categoriesListViewController: CategoriesListViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: CategoriesListViewController.self)) as? CategoriesListViewController else {
            fatalError(String(describing: CategoriesListViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    var productsViewController: ProductsViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: ProductsViewController.self)) as? ProductsViewController else {
            fatalError(String(describing: ProductsViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    
    var productDetailsPopUpViewController: ProductDetailsPopUpViewController {
        guard let viewController = instantiateViewController(withIdentifier: String(describing: ProductDetailsPopUpViewController.self)) as? ProductDetailsPopUpViewController else {
            fatalError(String(describing: ProductDetailsPopUpViewController.self) + "\(NSLocalizedString("couldn't be found in Storyboard file", comment: ""))")
        }
        return viewController
    }
    

    
    
}
