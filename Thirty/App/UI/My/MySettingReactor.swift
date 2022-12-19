//
//  MySettingReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/09/13.
//

import Foundation
import ReactorKit
import Moya

class MySettingReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case withDrawalTapped
    }
    
    enum Mutation {
        case withdrawal
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .withDrawalTapped:
            return requestSignOutRx()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .withdrawal:
            break
        }
        return state
    }
    
    private func requestSignOutRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in
            let provider = MoyaProvider<AuthAPI>()
            provider.request(.signOut) { result in
                switch result {
                case let .success(response):
                    let str = String(decoding: response.data, as: UTF8.self)
                    print(str)
                    observer.onNext(Mutation.withdrawal)
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
