//
//  String+Extension.swift
//  Thirty
//
//  Created by hakyung on 2022/09/23.
//

import Foundation

extension String {
    func iSO8601Date() -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self) ?? Date()
    }
    
    func dateYYMMDD() -> String {
        let yearCutIndex = self.index(self.startIndex, offsetBy: 2)
        let yyMMdd = String(self[yearCutIndex...]) // YY.MM.DD
        
        return yyMMdd
    }
    
    func dateMMDD() -> String {
        let yearCutIndex = self.index(self.startIndex, offsetBy: 5)
        let MMdd = String(self[yearCutIndex...]) // MM.DD
        
        return MMdd
    }
}
