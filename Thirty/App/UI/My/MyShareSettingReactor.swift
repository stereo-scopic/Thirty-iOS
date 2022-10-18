//
//  MyShareSettingReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/10/12.
//

import ReactorKit
import Moya

class MyShareSettingReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case changeVisibility(String)
    }
    
    enum Mutation {
        case changedVisibility(Bool)
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeVisibility(let visibility):
            return changeVisibilityRx(visibility)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .changedVisibility(let bool):
            break
        }
        return newState
    }
    
    private func changeVisibilityRx(_ visibility: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.changeVisibility(visibility)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    UserService.shared.getProfile()
                    observer.onNext(Mutation.changedVisibility(true))
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
