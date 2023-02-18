//
//  UIAnimatable.swift
//  GameApp
//
//  Created by Celil Aydın on 5.02.2023.
//

import Foundation
import MBProgressHUD

protocol UIAnimatable where Self: UIViewController {
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension UIAnimatable {
    
    func showLoadingAnimation() {
        DispatchQueue.main.async { [unowned self] in
            let isShown = view.subviews.filter({ $0 is MBProgressHUD }).isEmpty == false
            if !isShown {
                print("celil")
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
        }
    }
    
    func hideLoadingAnimation() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
}
