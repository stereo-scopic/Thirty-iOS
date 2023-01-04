//
//  CompleteChallengeDetailReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/12/22.
//

import Foundation
import ReactorKit
import Moya
import RxRelay

class CompletedChallengeDetailReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear(String)
        case selectBucketAnswer(Int)
    }
    
    enum Mutation {
        case getBucketDetail(BucketDetail)
        case selectBucketAnswer(Int)
    }
    
    struct State {
        var bucketDetail: BucketDetail?
        var selectedBucketAnswer: BucketAnswer?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .viewWillAppear(bucketId):
            return getBucketDetailRx(bucketId)
        case .selectBucketAnswer(let index):
            return Observable.just(.selectBucketAnswer(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketDetail(let bucketDetail):
            newState.bucketDetail = bucketDetail
        case .selectBucketAnswer(let index):
            if index < state.bucketDetail?.answers?.count ?? 0 {
                newState.selectedBucketAnswer = state.bucketDetail?.answers?[index]
            } else {
                newState.selectedBucketAnswer = BucketAnswer(answerid: nil, created_at: "아직 답변 전이에요.", updated_at: nil, music: nil, date: index, detail: "", image: nil, stamp: 0)
            }
        }
        return newState
    }
    
    private func getBucketDetailRx(_ bucketId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.getBucketDetail(bucketId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(BucketDetail.self)
                    observer.onNext(Mutation.getBucketDetail(result ?? BucketDetail(bucket: nil, answers: [])))
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
