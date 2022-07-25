//
//  Category.swift
//  Thirty
//
//  Created by hakyung on 2022/07/12.
//

import Foundation

struct Category: Codable {
    var category_id: Int
    var name: String
    var description: String
    var image: URL
}
