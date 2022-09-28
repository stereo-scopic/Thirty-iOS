//
//  Bucket.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/20.
//

import Foundation

struct BucketDetail: Codable {
    var bucket: Bucket?
    var answers: [BucketAnswer]?
}

struct Bucket: Codable {
    var id: String
    var userId: String
    var challenge: Challenge
    var count: Int
    var status: BucketStatus
    var created_at: String?
    var updated_at: String?
}

struct BucketAnswer: Codable {
    var id: Int?
    var created_at: String?
    var updated_at: String?
    var music: String?
    var date: Int
    var detail: String?
    var image: String?
    var stamp: Int
    var mission: String?
    
    init(id: Int? = nil, created_at: String = "", updated_at: String? = "", music: String? = "", date: Int = 0, detail: String? = "", image: String? = "", stamp: Int, mission: String? = "") {
        self.id = id
        self.created_at = created_at
        self.updated_at = updated_at
        self.music = music
        self.date = date
        self.detail = detail
        self.image = image
        self.stamp = stamp
        self.mission = mission
    }
}

enum BucketStatus: String, Codable {
    case none = ""
    /// 진행중
    case WRK
    /// 완료
    case CMP
    /// 중단
    case ABD
}
