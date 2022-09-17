//
//  SelectChallengeReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/08/27.
//

import ReactorKit
import Foundation
import Moya
import RxRelay

class SelectChallengeReactor: Reactor {
    enum Action {
        case setChallengeByTheme(String)
        case selectChallenge(Int)
    }
    
    enum Mutation {
        case setChallengeList([Challenge])
        case getToken(Token)
    }
    
    struct State {
        var selectedTheme: String = ""
        var challengeList: [Challenge] = []
        var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    }
    
    var challengeObservable = BehaviorRelay<[Challenge]>(value: [])
    var selectedIndex = PublishSubject<IndexPath>()
    var selectedTheme = BehaviorRelay<String>(value: "")
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setChallengeByTheme(let challengeTheme):
            return requestChallengeListRx(challengeTheme)
        case .selectChallenge(let challengeId):
            return addNewBieBucket(challengeId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setChallengeList(let challengeList):
            newState.challengeList = challengeList
        case .getToken(let token):
            try? TokenManager.shared.saveAccessToken(token.access_token ?? "")
            try? TokenManager.shared.saveRefreshToken(token.refresh_token ?? "")
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
    
    private func addNewBieBucket(_ challengeId: Int) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.addNewbie(challengeId)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(Token.self)
                    observer.onNext(Mutation.getToken(result ?? Token()))
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
