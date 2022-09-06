//
//  BucketAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/04.
//

import RxSwift
import Moya

enum BucketAPI {
    case addNewbie(_ challengeId: Int)
    case addCurrent(_ challengeId: Int)
}

extension BucketAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.38.15.60:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .addNewbie:
            return "/buckets/add/newbie"
        case .addCurrent:
            return "/buckets/add/current"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addNewbie, .addCurrent:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .addNewbie(let challengeId):
            return [
                "uuid": UUID().uuidString,
                "challenge": challengeId
            ]
        case .addCurrent(let challengeId):
            return [
                "challenge": challengeId
            ]
        }
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            }
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .addCurrent:
            return [
                "Authorization": "Bearer \( UserDefaults.standard.string(forKey: "access_token") ?? "")"
            ]
        case .addNewbie:
            return ["Content-Type": "application/json"]
        }
    }
}
