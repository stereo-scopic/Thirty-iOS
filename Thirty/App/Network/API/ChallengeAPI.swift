//
//  ChallengeAPI.swift
//  Thirty
//
//  Created by hakyung on 2022/04/20.
//
import RxSwift
import Moya

enum ChallengeAPI {
    case categoryList
    case challengeList(_ categoryName: String)
}

extension ChallengeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "")!
    }
    
    var path: String {
        switch self {
        case .categoryList:
            return "/challenges"
        case let .challengeList(categoryName):
            return "/challenges/\(categoryName)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categoryList,.challengeList:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
//        case let .explore(exploreIdx):
//            return [
//                "exploreIdx": exploreIdx
//            ]
        default:
            return nil
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
