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
        case setChallengeByTheme(String)
        case addChallenge(Int)
    }
    
    enum Mutation {
        case setChallengeList([Challenge])
        case addChallenge(String)
    }
    
    struct State {
        var challengeList: [Challenge] = []
        var addChallengeMessage = ""
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
        case .addChallenge(let challengeId):
            return addBucketRx(challengeId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setChallengeList(let challengeList):
            newState.challengeList = challengeList
            newState.addChallengeMessage = ""
        case .addChallenge(let message):
            newState.addChallengeMessage = message
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
    
    private func addBucketRx(_ challengeId: Int) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.addCurrent(challengeId)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.addChallenge(result?.message ?? ""))
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
