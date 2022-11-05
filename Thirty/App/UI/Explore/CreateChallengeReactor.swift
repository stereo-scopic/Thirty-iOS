//
//  CreateChallengeReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/10/26.
//

import ReactorKit
import Moya
import RxRelay

class CreateChallengeReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case enrollChallenge(String, String, [Mission])
        case addMissions(Int, String)
    }
    
    enum Mutation {
        case enrollChallengeAfter(Bool, String?)
        case addMissionDetail(Int, String)
    }
    
    struct State {
        var enrollMessage: String = ""
//        var inputMissions = BehaviorRelay<[Mission]>(value: [])
        var inputMissions: [Mission]
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .enrollChallenge(let challengeTitle, let challengeDescription, let missions):
            return enrollMyChallengeRx(challengeTitle, challengeDescription, missions)
        case .addMissions(let date, let detail):
            return Observable.just(.addMissionDetail(date, detail))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .enrollChallengeAfter(_, let message):
            newState.enrollMessage = message ?? ""
        case .addMissionDetail(let date, let detail):
//            var beforeMissions = newState.inputMissions.value
//            beforeMissions.append(Mission(date: date, detail: detail))
//            newState.inputMissions.accept(beforeMissions)
            newState.inputMissions.append(Mission(date: date, detail: detail))
        }
        return newState
    }
    
    private func enrollMyChallengeRx(_ challengeTitle: String, _ challengeDescription: String, _ missions: [Mission]) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<ChallengeAPI>()
            provider.request(.addMyChallenge(challengeTitle, challengeDescription, missions)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(CommonResponse.self)
                    observer.onNext(Mutation.enrollChallengeAfter(true, result?.message))
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
