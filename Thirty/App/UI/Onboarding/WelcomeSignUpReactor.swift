//
//  WelcomeSignUpReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/11/05.
//

import ReactorKit
import Moya

class WelcomeSignUpReactor: Reactor {
    var initialState: State = State(signUpFlag: false)
    
    enum Action {
        case signupButtonTapped(String, String, String)
    }
    
    enum Mutation {
        case signUp(Bool, String?)
    }
    
    struct State {
        var signUpFlag: Bool
        var signUpMessage: String?
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
        case .signUp(let flag, let message):
            newState.signUpFlag = flag
            newState.signUpMessage = message
        }
        return newState
    }
    
    private func signUpRx(_ id: String, _ pwd: String, _ nickname: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.signUpNewbie(id, pwd, nickname)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(CommonResponse.self)
                    if response.statusCode == 201 {
                        observer.onNext(Mutation.signUp(true, result?.message))
                    } else {
                        observer.onNext(Mutation.signUp(false, result?.message))
                    }
                    observer.onCompleted()
                case let .failure(error):
                    observer.onNext(Mutation.signUp(false, "잠시 후에 다시 시도해주세요."))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
