//
//  UserService.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/11.
//

import Foundation
import Moya

// protocol UserServiceType {
//    var myProfile: User? { get set }
// }

public class UserService {
    static let shared = UserService()
    
    var myProfile: User?
    
    func getProfile() {
        let provider = MoyaProvider<AuthAPI>()
        provider.request(.getProfile) { result in
            switch result {
            case .success(let response):
                let str = String(decoding: response.data, as: UTF8.self)
                print(str)
                let result = try? response.map(User.self)
                self.myProfile = result
            case .failure(let error):
                self.myProfile = nil
            }
        }
    }
}
