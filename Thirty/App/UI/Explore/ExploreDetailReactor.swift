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
        case addChallengeButtonTapped
    }
    
    enum Mutation {
        case setChallengeDetail(ChallengeDetail)
        case addChallenge
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
        case .addChallengeButtonTapped:
            return addBucket(challengeId: initialState.challengeId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setChallengeDetail(let challengeDetail):
            newState.challengeDetail = challengeDetail
        case .addChallenge:
            print("response 성공여부 처리")
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
    
    private func addBucket(challengeId: Int) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.addCurrent(challengeId)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
//                    let result = try? response.map(<#T##type: Decodable.Protocol##Decodable.Protocol#>)
                    // {"id":"5d54b4c7b84b4c751c5e0771e44c6b","created_at":"2022-09-04T23:51:02.076Z","updated_at":"2022-09-04T23:51:02.076Z","userId":"3386eab155dbc76dd631"}
                    observer.onNext(Mutation.addChallenge)
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
