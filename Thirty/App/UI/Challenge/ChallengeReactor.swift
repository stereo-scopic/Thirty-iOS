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
    }

    enum Mutation {
        case getBucketList([Bucket])
    }

    struct State {
        var bucketList: [Bucket]
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketList(let bucketList):
            newState.bucketList = bucketList
        }
        return newState
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return requestBucketListRx()
        }
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
 }
