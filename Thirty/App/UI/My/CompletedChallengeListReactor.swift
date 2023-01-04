//
//  CompletedChallengeListReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/12/21.
//

import Foundation
import ReactorKit
import Moya
import RxRelay

class CompletedChallengeListReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case getCompleteBucketList([Bucket])
    }
    
    struct State {
        var completedChallengeList: [Bucket] = []
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return requestCompleteChallengeListRx()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getCompleteBucketList(let bucketList):
            newState.completedChallengeList = bucketList
        }
        
        return newState
    }
    
    private func requestCompleteChallengeListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.getBucketList(BucketStatus.CMP.rawValue)) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print("완료 챌린지 목록 > \(str)")
                    
                    let result = try? response.map([Bucket].self)
                    observer.onNext(Mutation.getCompleteBucketList(result ?? []))
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
