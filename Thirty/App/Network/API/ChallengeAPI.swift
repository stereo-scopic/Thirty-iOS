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
    case challengeListInCategory(_ categoryName: String)
    case challengeDetail(_ categoryName: String, _ challengeId: Int)
    case addMyChallenge(_ challengeTitle: String, _ challengeDetail: String, _ missions: [Mission])
}

extension ChallengeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .categoryList, .addMyChallenge:
            return "/challenges"
        case let .challengeListInCategory(categoryName):
            return "/challenges/\(categoryName)"
        case let .challengeDetail(categoryName, categoryId):
            return "/challenges/\(categoryName)/\(categoryId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .categoryList, .challengeListInCategory, .challengeDetail:
            return .get
        case .addMyChallenge:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .addMyChallenge(let challengeTitle, let challengeDescription, let missions):
            return [
                "challenge": [
                    "title": challengeTitle,
                    "description": challengeDescription
                ],
                "missions": missions
            ]
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
