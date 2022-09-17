//
//  AuthAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/06.
//

import Moya

enum AuthAPI {
    case signUp(_ email: String, _ pwd: String, _ nickname: String)
    case signOut
    case login(_ email: String, _ pwd: String)
    case getProfile
    case changeProfile(_ nickname: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "auth/signup"
        case .signOut:
            return "auth/signout"
        case .login:
            return "auth/login"
        case .getProfile, .changeProfile:
            return "user/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .signOut, .login:
            return .post
        case .getProfile:
            return .get
        case .changeProfile:
            return .patch
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .signUp(let email, let pwd, let nickname):
            return [
                "email": email,
                "password": pwd,
                "nickname": nickname
            ]
        case .login(let email, let pwd):
            return [
                "email": email,
                "password": pwd
            ]
        case .signOut, .getProfile:
            return nil
        case .changeProfile(let nickname):
            return [
                "nickname": nickname
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
        return [
            "Authorization": "Bearer \(TokenManager.shared.loadAccessToken() ?? "")"
        ]
    }
}
