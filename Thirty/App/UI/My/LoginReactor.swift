//
//  LoginReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/11.
//

import ReactorKit
import Moya

class LoginReactor: Reactor {
    var initialState: State = State(loginFlag: false)
    
    enum Action {
       case loginButtonTapped(String, String)
    }
    
    enum Mutation {
        case login(Bool, String?)
    }
    
    struct State {
        var loginFlag: Bool
        var loginMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .loginButtonTapped(id, pwd):
            return loginRx(id, pwd)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .login(let flag, let message):
            newState.loginFlag = flag
            newState.loginMessage = message
        }
        
        return newState
    }
    
    private func loginRx(_ id: String, _ pwd: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.login(id, pwd)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(LoginResponse.self)
                    if let access_token = result?.access_token {
                        try? TokenManager.shared.saveAccessToken(access_token)
                        observer.onNext(Mutation.login(true, ""))
                    } else {
                        observer.onNext(Mutation.login(false, result?.message))
                    }
                    observer.onCompleted()
                case let .failure(error):
                    observer.onNext(Mutation.login(false, "잠시 후 다시 시도해주세요."))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
}
