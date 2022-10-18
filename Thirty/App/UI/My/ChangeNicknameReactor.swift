//
//  ChangeNicknameReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/09.
//

import Foundation
import ReactorKit
import Moya

class ChangeNicknameReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case changeNicknameButtonTapped(String)
    }
    
    enum Mutation {
        case nicknameChangeSuccess
    }
    
    struct State {

    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeNicknameButtonTapped(let nickname):
            return changeNicknameRx(nickname)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .nicknameChangeSuccess:
            break
        }
        return newState
    }
    
    private func changeNicknameRx(_ nickname: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.changeProfile(nickname)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    observer.onNext(Mutation.nicknameChangeSuccess)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
