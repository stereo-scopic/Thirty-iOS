//
//  ExploreDetailReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/08/26.
//
import ReactorKit
import Foundation
import RxSwift
import RxCocoa
import Moya

class ExploreDetailReactor: Reactor {
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case setChallengeDetail(ChallengeDetail)
    }
    
    struct State {
        var challengeDetail: ChallengeDetail = ChallengeDetail()
        var category: String = ""
        var challengeId: Int = 0
    }
    
    var challengeDetailObservable = BehaviorRelay<ChallengeDetail>(value: ChallengeDetail())
    var initialState: State = State()
    
    init(category: String, challengeId: Int) {
        self.initialState = State(challengeDetail: ChallengeDetail(), category: category, challengeId: challengeId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return requestMissionListRx(category: initialState.category, challengeId: initialState.challengeId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChallengeDetail(let challengeDetail):
            newState.challengeDetail = challengeDetail
        }
        return newState
    }
    
    private func requestMissionListRx(category: String, challengeId: Int) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            
            let provider = MoyaProvider<ChallengeAPI>()
            provider.request(.challengeDetail(category, challengeId)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(ChallengeDetail.self)
                    observer.onNext(Mutation.setChallengeDetail(result ??
                                                               ChallengeDetail()))
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
