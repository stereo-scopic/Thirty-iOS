//
//  ExploreModel.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import Foundation

struct Challenge: Codable {
    var id: Int?
    var created_at: String?
    var updated_at: String?
    var title: String?
    var description: String?
    var is_public: Bool?
    var category: Category? 
    var thumbnail: String?
}

struct CommunityChallengeItem: Decodable {
    var answerId: Int
    var bucketId: Int?
    var userId: String
    var nickname: String?
    var challenge: String?
    var mission: String?
    var date: Int?
    var image: String?
    var detail: String?
    var music: String?
    var stamp: Int?
    var created_at: String?
    var isFriend: Bool
}

struct ChallengeDetail: Codable {
    var id: Int?
    var created_at: String?
    var updated_at: String?
    var title: String?
    var description: String?
    var is_public: Bool?
    var category: Category?
    var missions: [Mission]?
    var bucketCount: Int?
}
