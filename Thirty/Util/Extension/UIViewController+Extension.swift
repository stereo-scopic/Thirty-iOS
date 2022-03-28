//
//  UIViewController+Extension.swift
//  Thirty
//
//  Created by hakyung on 2022/03/18.
//

import Foundation
import UIKit

extension UIViewController {
    func popVC(animated: Bool = false, completion: (() -> Void)?) {
        if self.isModal() {
            self.dismiss(animated: animated, completion: {
                completion?()
            })
        } else {
            self.navigationController?.popViewController(animated: animated)
        }
    }

    func isModal() -> Bool {
        if let navigationController = self.navigationController {
            if navigationController.viewControllers.first != self {
                return false
            }
        }

        if self.presentedViewController != nil {
            return true
        }

        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }

        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }

        return false
    }

}
