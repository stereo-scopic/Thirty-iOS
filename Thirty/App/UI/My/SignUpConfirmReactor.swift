//
//  SignUpConfirmReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/18.
//

import ReactorKit
import Moya

class SignUpConfirmReactor: Reactor {
    var initialState: State = State(signUpConfirmFlag: false)
    
    enum Action {
        case signUpConfirmTapped(String, String)
    }
    
    enum Mutation {
        case signUpConfirm(Bool, String?)
    }
    
    struct State {
        var signUpConfirmFlag: Bool
        var signUpConfirmMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signUpConfirmTapped(let email, let code):
            return signUpConfirmRx(email, Int(code) ?? 0)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .signUpConfirm(let flag, let message):
            newState.signUpConfirmFlag = flag
            newState.signUpConfirmMessage = message
        }
        
        return newState
    }
    
    private func signUpConfirmRx(_ email: String, _ code: Int) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.signUpConfirm(email, code)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(CommonResponse.self)
                    
                    if result?.statusCode == 201 {
                        observer.onNext(Mutation.signUpConfirm(true, result?.message))
                    } else {
                        observer.onNext(Mutation.signUpConfirm(false, result?.message))
                    }
                    observer.onCompleted()
                case let .failure(error):
                    observer.onNext(Mutation.signUpConfirm(false, "잠시 후에 다시 시도해주세요."))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
