//
//  FindFriendReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/10/07.
//

import ReactorKit
import Moya

class FindFriendReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case searchButtonTapped(String)
        case requestFriend(String)
    }
    
    enum Mutation {
        case getUserResult([User])
    }
    
    struct State {
        var resultUsers: [User]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchButtonTapped(let userId):
            return findUserRx(userId)
        case .requestFriend(let userId):
            return requestFriendRx(userId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getUserResult(let users):
            newState.resultUsers = users
        }
        return newState
    }
    
    private func findUserRx(_ userId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.findUser(userId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([User].self)
                    observer.onNext(Mutation.getUserResult(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func requestFriendRx(_ userId: String) -> Observable<Mutation>{
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.requestFriend(userId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    observer.onCompleted()
                case .failure(let error):
                    print(error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
