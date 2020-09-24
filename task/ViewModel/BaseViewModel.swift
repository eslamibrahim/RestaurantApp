//
//  task
//
//  Created by islam on 9/23/20.
//


import Foundation
import RxSwift
import RxCocoa
import SwiftMessages

class BaseViewModel {
    
    // Dispose Bag
    let disposeBag = DisposeBag()
    let alert = PublishSubject<(String, Theme)>()
    let alertDialog = PublishSubject<(String,String)>()
    
}
