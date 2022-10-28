//
//  Mission.swift
//  Thirty
//
//  Created by hakyung on 2022/08/26.
//

import Foundation

struct Mission: Codable {
    var id: Int?
    var date: Int
    var detail: String?
    var challengeTitle: String?
    
    init(id: Int? = nil, date: Int, detail: String, challengeTitle: String? = nil) {
        self.id = id
        self.date = date
        self.detail = detail
        self.challengeTitle = challengeTitle
    }
}
