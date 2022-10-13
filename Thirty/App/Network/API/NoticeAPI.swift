//
//  NoticeAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/03.
//

import Moya

enum NoticeAPI {
    case getNotification
    case responseRelation(_ friendId: String, status: ResponseFriedType)
    case getAnnouncement
}

extension NoticeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getNotification:
            return "/notification"
        case .responseRelation:
            return "/relation/RSVP"
        case .getAnnouncement:
            return "/notice"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNotification, .getAnnouncement:
            return .get
        case .responseRelation:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .responseRelation(let friendId, let responseFriedType):
            return [
                "friendId": friendId,
                "status": responseFriedType.rawValue
            ]
        default:
            return nil
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
        return [
            "Authorization": "Bearer \(TokenManager.shared.loadAccessToken() ?? "")"
//            "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1dWlkIjoiYWJjZGVmdSIsImlkIjoiZDM0MjA2MjcwN2VlZGEwZWYzZjIiLCJpYXQiOjE2NjQ3MDQxMTEsImV4cCI6MTY2NTMwODkxMX0.HEcRqGstzWsiQ6bDhw8z0SccUDpkg9D3SoPxxI7kxOs"
        ]
    }
}
