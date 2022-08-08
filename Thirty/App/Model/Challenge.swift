//
//  ExploreModel.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import Foundation

struct Category: Codable {
    var category_id: String
    var name: String
    var description: String
    var image: URL
}

struct Challenge: Codable {
    var challenge_id: String
    var category: String
    var title: String
    var description: String
    /// 공개여부
    var is_public: Bool
    /// null if no headers (authorization)
    var is_this_user_had_already: Bool
    var created_at: String
    var updated_at: String
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
