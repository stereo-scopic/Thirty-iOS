//
//  BucketDetailReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/03.
//

import ReactorKit
import Moya

class BucketDetailReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear(String, Int)
    }
    
    enum Mutation {
        case getBucketAnswerDetail(BucketAnswer)
    }
    
    struct State {
        var bucketAnswer: BucketAnswer?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear(let bucketId, let answerDate):
            return getBucketAnswerDetail(bucketId, answerDate)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketAnswerDetail(let bucketAnswer):
            newState.bucketAnswer = bucketAnswer
        }
        return newState
    }
    
    private func getBucketAnswerDetail(_ bucketId: String, _ answerDate: Int) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.getBucketAnswerDetail(bucketId, answerDate)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(BucketAnswer.self)
                    observer.onNext(Mutation.getBucketAnswerDetail(result ?? BucketAnswer(stamp: 0)))
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
