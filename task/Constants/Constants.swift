//  task
//
//  Created by islam on 9/23/20.
//


import Foundation
import UIKit

enum InternetConnectionErrorCode: Int {
    case offline = 10101
}

//MARK:- Global Variables
let Application  = UIApplication.shared.delegate as! AppDelegate

//MARK:- UIDevice Static Constants

let Screen                  = UIScreen.main.bounds.size

var SAFE_AREA_NOTCH_INSET: CGFloat{
    if #available(iOS 11.0, *) {
        let inset = UIApplication.shared.keyWindow?.safeAreaInsets
        return (inset?.top ?? 0) +  (inset?.bottom ?? 0)
    }else{
        return 0
    }
}


//MARK:- Delay Methods
public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}
