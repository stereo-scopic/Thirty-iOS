//
//  MyBadgeReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/17.
//

import ReactorKit
import Moya

class MyBadgeReactor: Reactor {
    enum Action {
        case setBadgeList
    }
    
    enum Mutation {
        case setBadgeList([Badge])
    }
    
    struct State {
        var badgeList: [Badge] = []
        var ownedCount: Int = 0
        var allCount: Int = 9
    }
    
    var initialState: State = State(badgeList: [])
    
    init() {
        self.initialState = State(badgeList: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setBadgeList:
            return requestBadgeListRx()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setBadgeList(let badgeList):
            newState.badgeList = badgeList
            
            let isOwnedCount = badgeList.filter { $0.isOwned }.count
            newState.ownedCount = isOwnedCount
            newState.allCount = badgeList.count
        }
        return newState
    }
    
    private func requestBadgeListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<RewardAPI>()
            provider.request(.getReward) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map([Badge].self)
                    observer.onNext(Mutation.setBadgeList(result ?? []))
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
