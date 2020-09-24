//
//  ActivityIndicatorViewable.swift
//  task
//
//  Created by islam on 9/23/20.
//

import UIKit
import MBProgressHUD


protocol ActivityIndicatorViewable {
    
    func showActivityIndicator(in _containerView:UIView?) -> Void
    func hideActivityIndicator(from containerView:UIView?) -> Void
}
extension ActivityIndicatorViewable where Self: UIViewController {
    
    func showActivityIndicator(in _containerView:UIView? = nil) -> Void {
        var containerView:UIView = self.view
        
        if let _containerView = _containerView {
            containerView = _containerView
        }
        
        hideActivityIndicator(from: containerView)
        
        let hud = MBProgressHUD.showAdded(to: containerView, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.backgroundView.color = UIColor.lightGray
        hud.backgroundView.style = .solidColor
        hud.show(animated: true)
    }
    
    func hideActivityIndicator(from _containerView:UIView? = nil) -> Void {
        var containerView:UIView = self.view
        
        if let _containerView = _containerView {
            containerView = _containerView
        }
        
        MBProgressHUD.hide(for: containerView, animated: true)
    }
}











