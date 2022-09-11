//
//  ExploreListReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/08/22.
//

import ReactorKit
import Foundation
import Moya
import RxRelay

class ExploreListReactor: Reactor {
    enum Action {
//        case viewWillAppear
        case setChallengeByTheme(String)
    }
    
    enum Mutation {
        case setChallengeList([Challenge])
    }
    
    struct State {
        var challengeList: [Challenge] = []
    }
    
    var challengeObservable = BehaviorRelay<[Challenge]>(value: [])
    var initialState: State = State()
    
    init() {
        self.initialState = State(challengeList: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setChallengeByTheme(let challengeTheme):
            return requestChallengeListRx(challengeTheme)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setChallengeList(let challengeList):
            newState.challengeList = challengeList
        }
        return newState
    }
    
    private func requestChallengeListRx(_ challengeTheme: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<ChallengeAPI>()
            provider.request(.challengeListInCategory(challengeTheme)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map([Challenge].self)
                    observer.onNext(Mutation.setChallengeList(result ?? []))
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
}
