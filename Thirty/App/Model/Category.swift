//
//  Category.swift
//  Thirty
//
//  Created by hakyung on 2022/07/12.
//

import Foundation

struct Category: Codable {
    var id: Int?
    var name: String?
    var description: String?
}

enum CategoryType: String {
    case hobby = "취미"
    case fan = "덕질"
    case love = "연애"
    case selfcare = "셀프케어"
    case diet = "다이어트"
    case fitness = "피트니스"
    case study = "공부"
}
