//
//  AuthAPI.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/06.
//

import Moya

enum AuthAPI {
    case signUp(_ email: String, _ pwd: String, _ nickname: String)
    case signUpConfirm(_ email: String, _ code: Int)
    case signOut
    case login(_ email: String, _ pwd: String)
    case getProfile
    case changeProfile(_ nickname: String)
    case findUser(_ userId: String)
    case changeVisibility(_ visibility: String)
    case requestFriend(_ userId: String)
    case getFriendList
    case deleteFriend(_ friendId: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://15.165.64.36:3000/api/v1")!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "auth/signup"
        case .signUpConfirm:
            return "auth/activate"
        case .signOut:
            return "auth/signout"
        case .login:
            return "auth/login"
        case .getProfile, .changeProfile, .changeVisibility:
            return "user/profile"
        case .findUser(let userId):
            return "user/\(userId)"
        case .requestFriend, .getFriendList, .deleteFriend:
            return "/relation"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .signUpConfirm, .signOut, .login, .requestFriend:
            return .post
        case .getProfile, .findUser, .getFriendList:
            return .get
        case .changeProfile, .changeVisibility:
            return .patch
        case .deleteFriend:
            return .delete
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
        case .signUpConfirm(let email, let code):
            return [
                "email": email,
                "code": code
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
        case .requestFriend(let userId):
            return [
                "friend": userId
            ]
        case .changeVisibility(let visibility):
            return [
                "visibility": visibility
            ]
        case .deleteFriend(let friendId):
            return [
                "friend": friendId
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
        ]
    }
}
