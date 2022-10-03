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
        case selectBucket(Bucket?)
        case selectBucketAnswer(Int)
    }

    enum Mutation {
        case getBucketList([Bucket])
        case selectBucketChanged(Bucket)
        case selectBucektDetailChanged(BucketDetail)
        case selectBucketAnswer(Int)
        case empty
    }

    struct State {
        var bucketList: [Bucket]
        var selectedBucket: Bucket?
        var selectedBucketDetail: BucketDetail?
        var selectedBucketAnswer: BucketAnswer?
    }

     func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewWillAppear:
             return requestBucketListRx()
         case .selectBucket(let bucket):
             if let bucket = bucket {
                 return Observable.concat([
                    Observable.just(.selectBucketChanged(bucket)),
                    getBucketDetailRx(bucket)
                 ])
             } else {
                 return Observable.just(.empty)
             }
         case .selectBucketAnswer(let index):
             return Observable.just(.selectBucketAnswer(index))
         }
     }
     
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketList(let bucketList):
            newState.bucketList = bucketList
            newState.selectedBucket = bucketList.first
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.action.onNext(.selectBucket(bucketList.first))
            }
        case .selectBucketChanged(let bucket):
            newState.selectedBucket = bucket
        case .selectBucektDetailChanged(let bucket):
            newState.selectedBucketDetail = bucket
        case .selectBucketAnswer(let index):
            if index < state.selectedBucketDetail?.answers?.count ?? 0 {
                newState.selectedBucketAnswer = state.selectedBucketDetail?.answers?[index]
            } else {
                newState.selectedBucketAnswer = BucketAnswer(answerid: nil, created_at: "아직 답변 전이에요.", updated_at: nil, music: nil, date: index, detail: "", image: nil, stamp: 0)
            }
        default:
            return newState
            
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
                     observer.onNext(Mutation.selectBucektDetailChanged(result ?? BucketDetail(bucket: nil, answers: [])))
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
