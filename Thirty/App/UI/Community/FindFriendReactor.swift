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
        case getUserResult(User)
        case requestFriendResponse(String)
    }
    
    struct State {
        var resultUsers: User?
        var responseMessage: String?
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
        case .getUserResult(let user):
            newState.resultUsers = user
        case .requestFriendResponse(let message):
            newState.responseMessage = message
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
                    
                    let result = try? response.map(User.self)
                    observer.onNext(Mutation.getUserResult(result ?? User()))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(Mutation.getUserResult(User()))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func requestFriendRx(_ userId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.requestFriend(userId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.requestFriendResponse(result?.message ?? "친구 신청이 완료되었습니다."))
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
