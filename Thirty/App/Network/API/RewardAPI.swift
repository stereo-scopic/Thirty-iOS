//
//  RewardAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/17.
//

import Moya

enum RewardAPI {
    case getReward
}

extension RewardAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getReward:
            return "/reward"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getReward:
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
