//
//  Badge.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/17.
//

import Foundation

struct Badge: Codable {
    var prize_code: String?
    var name: String?
    var illust: String?
    var created_at: String?
    var isOwned: Bool
}
