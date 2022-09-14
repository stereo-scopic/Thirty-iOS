//
//  SignUpReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/06.
//

import ReactorKit
import Foundation
import Moya

class SignUpReactor: Reactor {
    var initialState: State = State(signUpFlag: false)
    
    enum Action {
       case signupButtonTapped(String, String, String)
    }
    
    enum Mutation {
        case signUp(Bool)
    }
    
    struct State {
        var signUpFlag: Bool
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .signupButtonTapped(id, pwd, nickname):
            return signUpRx(id, pwd, nickname)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .signUp(let flag):
            newState.signUpFlag = flag
        }
        
        return newState
    }
    
    private func signUpRx(_ id: String, _ pwd: String, _ nickname: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.signUp(id, pwd, nickname)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(User.self)
                    if let _ = result?.id {
                        observer.onNext(Mutation.signUp(true))
                    } else {
                        observer.onNext(Mutation.signUp(false))
                    }
                    observer.onCompleted()
                case let .failure(error):
                    observer.onNext(Mutation.signUp(false))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
