//
//  UIView+IBDesignable.swift
//  Thirty
//
//  Created by hakyung on 2022/03/18.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    func showToast(message: String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let toastLabel = UILabel(frame: CGRect(x: 20, y: topController.view.frame.size.height - 122, width: topController.view.frame.size.width - 40, height: 44))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            toastLabel.textColor = UIColor.white
            toastLabel.font = font
            toastLabel.textAlignment = NSTextAlignment.center
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.clipsToBounds  =  true
            topController.view.addSubview(toastLabel)
            UIView.animate(withDuration: 3.0, delay: 1, options: .showHideTransitionViews, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(_) in
                toastLabel.removeFromSuperview()
            })
        }
        
    }
}
