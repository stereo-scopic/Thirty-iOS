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

func korNameOfCategory(_ type: CategoryType.RawValue?) -> String {
    switch type {
    case "취미": return "HOBBY"
    case "덕질": return "FAN"
    case "연애": return "LOVE"
    case "셀프케어": return "SELFCARE"
    case "다이어트": return "DIET"
    case "피트니스": return "FITNESS"
    case "공부": return "STUDY"
    default: return ""
    }
}
