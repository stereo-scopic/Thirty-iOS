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
        case enrollAnswer(String, BucketAnswer, UIImage?)
        case editAnswer(String, Int, BucketAnswer, UIImage?)
//        case imageSelected
//        case linkSelected
//        case badgeSelected
    }
    
    enum Mutation {
        case enrollSuccess(Bool)
        case bucketCompleted(Bool, BucketStatus)
    }
    
    struct State {
        var bucketAnswer: BucketAnswer
        var enrollStatus: Bool = false
        var bucketCompleted: Bool = false
        var bucketStatus: BucketStatus = .WRK
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .enrollAnswer(let bucketId, let bucketAnswer, let coverImage):
            return enrollBucketAnswerRx(bucketId, bucketAnswer, coverImage)
        case .editAnswer(let bucketId, let answerDate, let bucketAnswer, let coverImage):
            return editBucketAnswerRx(bucketId, answerDate, bucketAnswer, coverImage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .enrollSuccess(let successFlag):
            newState.enrollStatus = successFlag
        case .bucketCompleted(let endFlag, let bucketStatus):
            newState.bucketCompleted = endFlag
            newState.bucketStatus = bucketStatus
        }
        return newState
    }
    
    private func enrollBucketAnswerRx(_ bucketId: String, _ bucketAnswer: BucketAnswer, _ cover_image: UIImage?) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.enrollBucketAnswer(bucketId, bucketAnswer, cover_image)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(BucketStatusResponse.self)
                    var bucketStatus = BucketStatus.WRK
                    if result?.bucketStatus == "CMP" { bucketStatus = BucketStatus.CMP }
                    observer.onNext(.bucketCompleted(true, bucketStatus))
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func editBucketAnswerRx(_ bucketId: String, _ answerDate: Int, _ bucketAnswer: BucketAnswer, _ cover_image: UIImage?) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.editBucketAnswer(bucketId, answerDate, bucketAnswer, cover_image)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    observer.onNext(.enrollSuccess(true))
//                    if let _ = try? response.map(Bucket.self) {
//                    } else {
//                        observer.onNext(.enrollSuccess(false))
//                    }
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
