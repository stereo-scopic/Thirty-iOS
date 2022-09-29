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
}
