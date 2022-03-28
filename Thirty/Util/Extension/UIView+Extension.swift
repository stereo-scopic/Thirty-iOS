//
//  UIView+Extension.swift
//  Thirty
//
//  Created by hakyung on 2022/03/18.
//

import UIKit

extension UIView {
    func topRoundCorner(corners: UIRectCorner = [.topLeft, .topRight], radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
    }
}
