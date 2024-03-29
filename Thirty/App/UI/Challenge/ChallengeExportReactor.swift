//
//  ChallengeExportReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/10/06.
//

import Foundation
import ReactorKit
import Moya

class ChallengeExportReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear(String)
    }
    
    enum Mutation {
        case getBucketDetail(BucketDetail)
    }
    
    struct State {
        var bucketDetail: BucketDetail?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear(let bucketId):
            return getBucketDetailRx(bucketId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketDetail(let bucketDetail):
            newState.bucketDetail = bucketDetail
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
