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
        case viewWillAppear
//        case selectChallenge
    }
    
    enum Mutation {
        case setChallengeList([Challenge])
    }
    
    struct State {
        var challengeList: [Challenge] = []
        var selectedIndex: IndexPath = IndexPath(row: 0, section: 0)
    }
    
    var challengeObservable = BehaviorRelay<[Challenge]>(value: [])
    var selectedIndex = PublishSubject<IndexPath>()
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return requestChallengeListRx()
//        case .selectChallenge:
            
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
    
    private func requestChallengeListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<ChallengeAPI>()
            provider.request(.challengeListInCategory("취미")) { result in
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
