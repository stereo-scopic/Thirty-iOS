//
//  NoticeReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/03.
//

import ReactorKit
import Moya

class NoticeReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear
        case friendAcceptButtonClicked(String)
        case friendRefuseButtonClicked(String)
    }
    
    enum Mutation {
        case getNoticeList([Notice])
        case friendResponse(Bool)
    }
    
    struct State {
        var noticeList: [Notice]?
        var friendResponseSuccess: Bool?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.concat([
                getNoticeList(),
                readAllNoticeRx()
            ])
        case .friendAcceptButtonClicked(let friendId):
            return responseToFriendRelation(friendId: friendId, type: ResponseFriedType.confirmed)
        case .friendRefuseButtonClicked(let friendId):
            return responseToFriendRelation(friendId: friendId, type: ResponseFriedType.denied)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getNoticeList(let noticeList):
            newState.friendResponseSuccess = false
            newState.noticeList = noticeList
        case .friendResponse(let bool):
            newState.friendResponseSuccess = bool
        }
        return newState
    }
    
    private func getNoticeList() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<NoticeAPI>()
            provider.request(.getNotification) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([Notice].self)
                    observer.onNext(Mutation.getNoticeList(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func responseToFriendRelation(friendId: String, type: ResponseFriedType) -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<NoticeAPI>()
            provider.request(.responseRelation(friendId, status: type)) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    observer.onNext(Mutation.friendResponse(true))
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func readAllNoticeRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<NoticeAPI>()
            provider.request(.readAllNotice) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
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
