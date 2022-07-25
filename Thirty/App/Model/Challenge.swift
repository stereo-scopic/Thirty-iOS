//
//  ExploreModel.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import Foundation

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
