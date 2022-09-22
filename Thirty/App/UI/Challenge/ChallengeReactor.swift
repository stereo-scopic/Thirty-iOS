//
//  ChallengeReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/17.
//

import ReactorKit
import Moya

 class ChallengeReactor: Reactor {
    var initialState: State = State(bucketList: [])

    enum Action {
        case viewWillAppear
        case selectBucket(Bucket)
    }

    enum Mutation {
        case getBucketList([Bucket])
        case selectBucketChanged(Bucket)
        case selectBucektDetailChanged(BucketDetail)
    }

    struct State {
        var bucketList: [Bucket]
        var selectedBucket: Bucket?
        var selectedBucketDetail: BucketDetail?
    }

     func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewWillAppear:
             return requestBucketListRx()
         case .selectBucket(let bucket):
             return Observable.concat([
                Observable.just(.selectBucketChanged(bucket)),
                getBucketDetailRx(bucket)
             ])
         }
     }
     
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketList(let bucketList):
            newState.bucketList = bucketList
        case .selectBucketChanged(let bucket):
            newState.selectedBucket = bucket
        case .selectBucektDetailChanged(let bucket):
            newState.selectedBucketDetail = bucket
        }
        return newState
    }
    
     private func requestBucketListRx() -> Observable<Mutation> {
         let response = Observable<Mutation>.create { observer in
             let provider = MoyaProvider<BucketAPI>()
             provider.request(.getBucketList(BucketStatus.WRK.rawValue)) { result in
                 switch result {
                 case let .success(response):
                     let str = String(decoding: response.data, as: UTF8.self)
                     print(str)
                     
                     let result = try? response.map([Bucket].self)
                     observer.onNext(Mutation.getBucketList(result ?? []))
                     observer.onCompleted()
                 case let .failure(error):
                     observer.onError(error)
                 }
             }
             return Disposables.create()
         }
         return response
     }
     
     private func getBucketDetailRx(_ bucket: Bucket) -> Observable<Mutation> {
         let response = Observable<Mutation>.create { observer in
             let provider = MoyaProvider<BucketAPI>()
             provider.request(.getBucketDetail(bucket.id)) { result in
                 switch result {
                 case .success(let response):
                     let str = String(decoding: response.data, as: UTF8.self)
                     print(str)
                     
                     let result = try? response.map(BucketDetail.self)
                     observer.onNext(Mutation.selectBucektDetailChanged(result ?? BucketDetail(bucket: nil, answer: [])))
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
