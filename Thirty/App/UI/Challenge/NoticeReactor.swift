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
    }
    
    enum Mutation {
        case getNoticeList([Notice])
    }
    
    struct State {
        var noticeList: [Notice]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return getNoticeList()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getNoticeList(let noticeList):
            newState.noticeList = noticeList
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
    
}
