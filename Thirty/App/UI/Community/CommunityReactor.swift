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
        case reportUser(String)
        case blockUser(String)
    }
    
    enum Mutation {
        case getAllCommunityList([CommunityChallenge2])
        case getFriendCommunityList([CommunityChallenge2])
        case reportUser(String)
        case blockUser(String)
    }
    
    struct State {
        var allCommunityList: [CommunityChallenge2]?
        var friendCommunityList: [CommunityChallenge2]?
        var serverMessage: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .allCommunityDidAppear:
            return getAllCommunityListRx()
        case .friendCommunityDidAppear:
            return getFriendCommunityListRx()
        case .requestFriend(let userId):
            return requestFriendRx(userId)
        case .reportUser(let targetUserId):
            return reportUserRx(targetUserId)
        case .blockUser(let targetUserId):
            return blockUserRx(targetUserId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getAllCommunityList(let allCommunityList):
            newState.allCommunityList = allCommunityList
            newState.serverMessage = ""
        case .getFriendCommunityList(let friendCommunityList):
            newState.friendCommunityList = friendCommunityList
            newState.serverMessage = ""
        case .blockUser(let message):
            newState.serverMessage = message
        case .reportUser(let message):
            newState.serverMessage = message
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
    
    private func reportUserRx(_ targetUserId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.reportUser(targetUserId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.reportUser(result?.message ?? ""))
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
    
    private func blockUserRx(_ targetUserId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.blockUser(targetUserId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.blockUser(result?.message ?? ""))
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
