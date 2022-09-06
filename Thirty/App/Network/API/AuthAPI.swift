//
//  AuthAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/06.
//

import Moya

enum AuthAPI {
    case signUp(_ email: String, _ pwd: String)
    case signOut
    case login(_ email: String, _ pwd: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://3.38.15.60:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .signUp(_, _):
            return "auth/signup"
        case .signOut:
            return "auth/signout"
        case .login(_, _):
            return "auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp(_, _), .signOut, .login(_, _):
            return .post
        }
        
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .signUp(let email, let pwd):
            return [
                "email": email,
                "password": pwd,
                "password_repeat": pwd
            ]
        case .login(let email, let pwd):
            return [
                "email": email,
                "password": pwd
            ]
        case .signOut:
            return nil
        }
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
