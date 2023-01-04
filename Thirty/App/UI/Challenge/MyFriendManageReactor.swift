//
//  MyFriendManageReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/11/22.
//

import ReactorKit
import Moya

class MyFriendManageReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case friendButtonTapped
        case blockButtonTapped
        case deleteFriendTapped(String)
        case unblockUserTapped(String)
    }
    
    enum Mutation {
        case getFriendList([FriendAndBlockUser])
        case getBlockUserList([FriendAndBlockUser])
        case deleteFriendAfter(Bool, String)
        case unBlockUserAfter(Bool, String)
    }
    
    struct State {
//        var friendList: [Friend]?
//        var blockUserList: [BlockUser]?
        var serverMessage: String?
        var friendAndBlockUserList: [FriendAndBlockUser]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .friendButtonTapped:
            return getFriendListRx()
        case .blockButtonTapped:
            return getBlockUserListRx()
        case .deleteFriendTapped(let friendId):
            return deleteFriendRx(friendId)
        case .unblockUserTapped(let userId):
            return unBlockUserRx(userId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getFriendList(let friendList):
            newState.friendAndBlockUserList = friendList
        case .getBlockUserList(let blockUserList):
            newState.friendAndBlockUserList = blockUserList
        case .deleteFriendAfter(let bool, let message):
            if bool {
                self.action.onNext(.friendButtonTapped)
                newState.serverMessage = message
            }
        case .unBlockUserAfter(let bool, let message):
            if bool {
                self.action.onNext(.blockButtonTapped)
                newState.serverMessage = message
            }
        }
        return newState
    }
    
    private func getFriendListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.getFriendList) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([FriendAndBlockUser].self)
                    observer.onNext(Mutation.getFriendList(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func deleteFriendRx(_ friendId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.deleteFriend(friendId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.deleteFriendAfter(true, result?.message ?? ""))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(Mutation.deleteFriendAfter(false, ""))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func getBlockUserListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.getblockUserList) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([FriendAndBlockUser].self)
                    observer.onNext(Mutation.getBlockUserList(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func unBlockUserRx(_ targetUserId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.unblockUser(targetUserId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.unBlockUserAfter(true, result?.message ?? ""))
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
