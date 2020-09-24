//
//  task
//
//  Created by islam on 9/23/20.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController, AlerteableViewController, ActivityIndicatorViewable {

    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

