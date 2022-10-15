//
//  Notice.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/03.
//

import Foundation

struct Notice: Codable {
    var id: Int?
    var created_at: String?
    var updated_at: String?
    var relatedUserId: String?
    var relatedUserNickname: String?
    var type: String?
    var message: String?
    var is_read: Bool?
}
