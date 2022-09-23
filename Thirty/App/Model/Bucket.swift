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
    var created_at: String
    var updated_at: String?
    var music: String?
    var date: Int
    var detail: String?
    var image: String?
    var stamp: Int?
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
