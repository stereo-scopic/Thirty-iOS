//
//  BucketAnswerEnrollReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/09/27.
//

import Foundation
import ReactorKit
import Moya

class BucketAnswerEnrollReactor: Reactor {
    var initialState: State = State(bucketAnswer: BucketAnswer(stamp: 0))
    
    init(_ bucketAnswer: BucketAnswer) {
        self.initialState = State(bucketAnswer: bucketAnswer)
    }
    
    enum Action {
//        case viewWillAppear(BucketAnswer)
        case enrollAnswer(String, BucketAnswer)
//        case imageSelected
//        case linkSelected
//        case badgeSelected
    }
    
    enum Mutation {
//        case setBucketAnswer(BucketAnswer)
        case enrollSuccess(Bool)
    }
    
    struct State {
        var bucketAnswer: BucketAnswer
        var enrollStatus: Bool = false
//        var changedImage:
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .viewWillAppear(let bucketAnswer):
//            return Observable.just(.setBucketAnswer(bucketAnswer))
        case .enrollAnswer(let bucketId, let bucketAnswer):
            return enrollBucketAnswerRx(bucketId, bucketAnswer)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
//        case .setBucketAnswer(let bucketAnswer):
//            newState.bucketAnswer = bucketAnswer
        case .enrollSuccess(let successFlag):
            newState.enrollStatus = successFlag
        }
        return newState
    }
    
    private func enrollBucketAnswerRx(_ bucketId: String, _ bucketAnswer: BucketAnswer) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.enrollBucketAnswer(bucketId, bucketAnswer)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    if let _ = try? response.map(Bucket.self) {
                        observer.onNext(.enrollSuccess(true))
                    } else {
                        observer.onNext(.enrollSuccess(false))
                    }
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
