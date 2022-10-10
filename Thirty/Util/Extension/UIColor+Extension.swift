//
//  ColorConstants.swift
//  Thirty
//
//  Created by hakyung on 2022/03/21.
//

import UIKit

extension UIColor {
    static let gray50 = UIColor.init(named: "Gray50")
    static let gray100 = UIColor.init(named: "Gray100")
    static let gray200 = UIColor.init(named: "Gray200")
    static let gray300 = UIColor.init(named: "Gray300")
    static let gray400 = UIColor.init(named: "Gray400")
    static let gray500 = UIColor.init(named: "Gray500")
    static let gray600 = UIColor.init(named: "Gray600")
    static let gray700 = UIColor.init(named: "Gray700")
    static let gray800 = UIColor.init(named: "Gray800")

    static let thirtyBlack = UIColor.init(named: "THIRTY Black")
    static let thirtyBlue = UIColor.init(named: "THIRTY Blue")
    static let thirtyGreen = UIColor.init(named: "THIRTY Green")
    static let thirtyPink = UIColor.init(named: "THIRTY Pink")
    static let thirtyRed = UIColor.init(named: "THIRTY Red")
    static let thirtyWhite = UIColor.init(named: "THIRTY White")
    static let thirtyYellow = UIColor.init(named: "THIRTY Yellow")
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
