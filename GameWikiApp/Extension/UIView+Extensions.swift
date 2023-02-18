//
//  UIView+Extensions.swift
//  GameApp
//
//  Created by Celil Aydın on 4.02.2023.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {return cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
