//
//  Community.swift
//  Thirty
//
//  Created by 송하경 on 2022/07/24.
//

import Foundation
import UIKit

struct CommunityChallenge {
    var userNickname: String
    var challengeTitle: String
    var challengeOrder: Int
    var challengeName: String
    var challengeDetail: String
    var challengeDate: String
    var challengeImage: UIImage?
    var isExpanded: Bool
}

struct CommunityChallenge2: Decodable {
    var answerId: Int?
    var bucketId: Int?
    var userId: String?
    var usernickname: String?
    var challenge: String?
    var mission: String?
    var date: Int
    var image: String?
    var detail: String?
    var music: String?
    var stamp: Int?
    var created_at: String?
    var isFriend: Bool?
}
