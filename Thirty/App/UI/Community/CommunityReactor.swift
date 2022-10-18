//
//  CommunityReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/10.
//

import ReactorKit
import Moya

class CommunityReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case allCommunityDidAppear
        case friendCommunityDidAppear
        case requestFriend(String)
    }
    
    enum Mutation {
        case getAllCommunityList([CommunityChallenge2])
        case getFriendCommunityList([CommunityChallenge2])
    }
    
    struct State {
        var allCommunityList: [CommunityChallenge2]?
        var friendCommunityList: [CommunityChallenge2]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .allCommunityDidAppear:
            return getAllCommunityListRx()
        case .friendCommunityDidAppear:
            return getFriendCommunityListRx()
        case .requestFriend(let userId):
            return requestFriendRx(userId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getAllCommunityList(let allCommunityList):
            newState.allCommunityList = allCommunityList
        case .getFriendCommunityList(let friendCommunityList):
            newState.friendCommunityList = friendCommunityList
        }
        return newState
    }
    
    private func getAllCommunityListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<CommunityAPI>()
            provider.request(.getAllCommunityList) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([CommunityChallenge2].self)
                    observer.onNext(Mutation.getAllCommunityList(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func getFriendCommunityListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<CommunityAPI>()
            provider.request(.getFriendCommunityList) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([CommunityChallenge2].self)
                    observer.onNext(Mutation.getFriendCommunityList(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
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
