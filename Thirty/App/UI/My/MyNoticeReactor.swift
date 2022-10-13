//
//  MyNoticeReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/10/13.
//

import ReactorKit
import Moya

class MyNoticeReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case viewWillAppear
    }
    
    enum Mutation {
        case getAnnouncementList([Announcement])
    }
    
    struct State {
        var announcementList: [Announcement]?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return getAnnouncementRx()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .getAnnouncementList(let announcementList):
            newState.announcementList = announcementList
        }
        return newState
    }
    
    private func getAnnouncementRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<NoticeAPI>()
            provider.request(.getAnnouncement) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([Announcement].self)
                    observer.onNext(Mutation.getAnnouncementList(result ?? []))
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
