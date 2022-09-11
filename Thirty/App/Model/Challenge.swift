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
    var challenge_id: Int
    var challenge_title: String?
    var user_id: Int
    var user_nickname: String?
    var answer_id: Int
    var date: Int
    var music: String?
    var stamp: String?
    var detail: String?
    var original_image: String?
    var created_at: String?
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
}
