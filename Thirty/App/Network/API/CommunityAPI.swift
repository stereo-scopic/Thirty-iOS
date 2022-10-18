//
//  CommunityAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/09.
//

import Moya

enum CommunityAPI {
    case getAllCommunityList
    case getFriendCommunityList
}

extension CommunityAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getAllCommunityList:
            return "/community/all"
        case .getFriendCommunityList:
            return "/community/Friend"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        return nil
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
            ]
    }
}
