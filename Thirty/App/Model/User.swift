//
//  User.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/09.
//

import Foundation

struct UserInfo: Decodable {
    var user: User
    var rewardCount: Int?
    var completedChallengeCount: Int?
    var relationCount: Int?
    
    init() {
        user = User()
        rewardCount = 0
        completedChallengeCount = 0
        relationCount = 0
    }
}

struct User: Codable {
    var id: String?
    var uuid: String?
    var email: String?
    var nickname: String?
    var date_joined: String?
    var updated_at: String?
    var type: String?
    var visibility: String?
    var deleted_at: String?
    
    init() {
        id = ""
        uuid = ""
        email = ""
        nickname = ""
        date_joined = ""
        updated_at = ""
        type = ""
        visibility = ""
        deleted_at = ""
    }
}
