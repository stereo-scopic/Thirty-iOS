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

enum ResponseFriedType: String {
    case confirmed
    case denied
}

struct Friend: Codable {
    var friendId: String?
    var status: String?
    var created_at: String?
    var friendNickname: String?
}

struct LoginResponse: Codable {
    var access_token: String?
    var statusCode: Int?
    var message: String?
}

struct CommonResponse: Codable {
    var statusCode: Int?
    var message: String?
}

struct BlockUser: Codable {
    var id: Int?
    var created_at: String?
    var updated_at: String?
    var targetUser: TargetUser?
}

struct TargetUser: Codable {
    var id: String?
    var nickname: String?
}

struct FriendAndBlockUser: Codable {
    var friendId: String?
    var status: String?
    var created_at: String?
    var friendNickname: String?
    
    var id: Int?
    var updated_at: String?
    var targetUser: TargetUser?
}
