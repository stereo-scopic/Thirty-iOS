//
//  Date+Extension.swift
//  Thirty
//
//  Created by hakyung on 2022/09/23.
//

import Foundation

extension Date {
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: self)
    }
}
