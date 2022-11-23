//
//  MyFriendManageReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/11/22.
//

import ReactorKit
import Moya

class MyFriendManageReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case friendButtonTapped
        case blockButtonTapped
    }
    
    enum Mutation {
        case getFriendList([Friend])
        case getBlockUserList([BlockUser])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .friendButtonTapped:
            return getFriendListRx()
        case .blockButtonTapped:
            return getBlockUserListRx()
        }
    }
    
    private func getFriendListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.getFriendList) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([Friend].self)
                    observer.onNext(Mutation.getFriendList(result ?? []))
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        return response
    }
    
    private func getBlockUserListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.getblockUserList) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    
                    let result = try? response.map([Friend].self)
                    observer.onNext(Mutation.getBlockUserList(result ?? []))
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
