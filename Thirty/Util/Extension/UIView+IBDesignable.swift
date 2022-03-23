//
//  UIView+IBDesignable.swift
//  Thirty
//
//  Created by hakyung on 2022/03/18.
//

import Foundation
import UIKit


extension UIView{
    @IBInspectable
    var cornerRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
