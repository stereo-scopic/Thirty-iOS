//
//  Network.swift
//  Thirty
//
//  Created by hakyung on 2022/04/07.
//

import Moya


enum ThirtyService {
    case challenge
    case explore(_ exploreIdx: String)
}

extension ThirtyService: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .challenge:
            return "/challenge"
        case .explore:
            return "/explore"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .challenge, .explore:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .challenge:
            return [:]
        case let .explore(exploreIdx):
            return [
                "exploreIdx": exploreIdx
            ]
        }
    }
    
    var task: Task {
        switch self {
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            }
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
}
