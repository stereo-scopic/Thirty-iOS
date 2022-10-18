//
//  MyReactor.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/09.
//

import ReactorKit
import Moya

class MyReactor: Reactor {
    var initialState: State = State(userInfo: UserInfo())
    
    enum Action {
        case getInfo
    }
    
    enum Mutation {
        case getAuthInfo(UserInfo)
    }
    
    struct State {
        var userInfo: UserInfo
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getInfo:
            return getUserInfo()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .getAuthInfo(let userInfo):
            newState.userInfo = userInfo
        }
        return newState
    }
        
    private func getUserInfo() -> Observable<Mutation> {
//        let observer = Observable<Mutation>.create { observer in
//            observer.onNext(Mutation.getAuthInfo(UserService.shared.myProfile ?? User()))
//            
//        }
        
        UserService.shared.getProfile()
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.getProfile) { result in
                switch result {
                case .success(let response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    let result = try? response.map(UserInfo.self)
                    observer.onNext(Mutation.getAuthInfo(result ?? UserInfo()))
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
