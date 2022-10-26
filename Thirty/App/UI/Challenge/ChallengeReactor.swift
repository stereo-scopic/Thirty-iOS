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
        case viewWillAppear(Int)
        case selectBucket(Bucket?)
        case selectBucketAnswer(Int)
        case stopChallenge(String)
        case initChallenge(String)
    }

    enum Mutation {
        case getBucketList([Bucket], Int)
        case selectBucketChanged(Bucket)
        case selectBucektDetailChanged(BucketDetail)
        case selectBucketAnswer(Int)
        case unreadNoticeFlag(Bool)
        case stopChallengeAfter(Bool)
        case initChallengeAfter(Bool, String?)
        case empty
    }

    struct State {
        var bucketList: [Bucket]?
        var selectedBucket: Bucket?
        var selectedBucketDetail: BucketDetail?
        var selectedBucketAnswer: BucketAnswer?
        var unreadNoticeFlag: Bool?
        var stopChallenge: Bool = false
        var initChallenge: Bool = false
        var deleteMessage: String = ""
    }

     func mutate(action: Action) -> Observable<Mutation> {
         switch action {
         case .viewWillAppear(let selectedIndex):
             return Observable.concat([
                requestBucketListRx(selectedIndex),
                unreadNotiRx()
             ])
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
         case .stopChallenge(let challegeId):
             return stopChallengeRx(challegeId)
         case .initChallenge(let challengeId):
             return initChallengeRx(challengeId)
         }
     }
     
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getBucketList(let bucketList, let selectedIndex):
            newState.bucketList = bucketList
            newState.stopChallenge = false
            newState.initChallenge = false
            newState.deleteMessage = ""
            if !bucketList.isEmpty {
                newState.selectedBucket = bucketList[selectedIndex]
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.action.onNext(.selectBucket(bucketList[selectedIndex]))
                }
            }

        case .selectBucketChanged(let bucket):
            newState.selectedBucket = bucket
            newState.selectedBucketAnswer = BucketAnswer(stamp: 0)
        case .selectBucektDetailChanged(let bucket):
            newState.selectedBucketDetail = bucket
        case .selectBucketAnswer(let index):
            if index < state.selectedBucketDetail?.answers?.count ?? 0 {
                newState.selectedBucketAnswer = state.selectedBucketDetail?.answers?[index]
            } else {
                newState.selectedBucketAnswer = BucketAnswer(answerid: nil, created_at: "아직 답변 전이에요.", updated_at: nil, music: nil, date: index, detail: "", image: nil, stamp: 0)
            }
        case .unreadNoticeFlag(let isLeft):
            newState.unreadNoticeFlag = isLeft
        case .stopChallengeAfter(let bool):
            newState.stopChallenge = bool
        case .initChallengeAfter(let bool, let message):
            newState.initChallenge = bool
            newState.deleteMessage = message ?? ""
        default:
            return newState
            
        }
        return newState
    }
    
    private func requestBucketListRx(_  selectedIndex: Int) -> Observable<Mutation> {
         let response = Observable<Mutation>.create { observer in
             let provider = MoyaProvider<BucketAPI>()
             provider.request(.getBucketList(BucketStatus.WRK.rawValue)) { result in
                 switch result {
                 case let .success(response):
                     let str = String(decoding: response.data, as: UTF8.self)
                     print(str)
                     
                     let result = try? response.map([Bucket].self)
                     observer.onNext(Mutation.getBucketList(result ?? [], selectedIndex))
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
    
    private func stopChallengeRx(_ bucketId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.stopChallengeByStatus(bucketId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    observer.onNext(Mutation.stopChallengeAfter(true))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func initChallengeRx(_ bucketId: String) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<BucketAPI>()
            provider.request(.initChallenge(bucketId)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(CommonResponse.self)
                    if let message = result?.message {
                        observer.onNext(Mutation.initChallengeAfter(true, message))
                    } else {
                        observer.onNext(Mutation.initChallengeAfter(false, ""))
                    }
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func unreadNotiRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<NoticeAPI>()
            provider.request(.getUnreadFlag) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map(NoticeUnreadResponse.self)
                    if let isLeft = result?.isLeft {
                        observer.onNext(Mutation.unreadNoticeFlag(isLeft))
                    } else {
                        observer.onNext(Mutation.unreadNoticeFlag(false))
                    }
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
