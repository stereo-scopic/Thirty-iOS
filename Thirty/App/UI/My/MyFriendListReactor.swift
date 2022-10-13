//
//  MyNoticeReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/10/13.
//

import ReactorKit
import Moya

class MyFriendListReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear
        case deleteFriend(String)
    }
    
    enum Mutation {
        case getFriendList([Friend])
        case deleteFriendAfter(Bool)
    }
    
    struct State {
        var friendList: [Friend]?
        var deleteFriendFlag: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return getFriendListRx()
        case .deleteFriend(let friendId):
            return deleteFriendRx(friendId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getFriendList(let friendList):
            newState.friendList = friendList
        case .deleteFriendAfter(let flag):
            newState.deleteFriendFlag = flag
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
                    
                    let result = try? response.map([Friend].self)
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
                    
//                    let result = try? response.map([Friend].self)
//                    observer.onNext(Mutation.getFriendList(result ?? []))
                    observer.onNext(Mutation.deleteFriendAfter(true))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onNext(Mutation.deleteFriendAfter(false))
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
