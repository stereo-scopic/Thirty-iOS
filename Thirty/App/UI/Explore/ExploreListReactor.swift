//
//  ExploreListReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/07/12.
//
import ReactorKit
import Foundation
import RxSwift
import RxRelay
import Moya

class ExploreListReactor: Reactor {
    enum Action {
        case refresh
        case load
        case viewWillAppear
    }
    
    enum Mutation {
        case setLoading(loading: Bool)
        case setCategoryList([Category])
    }
    
    struct State {
        var loading: Bool = false
        var categoryList: [Category] = []
    }
    
    var categoryObservable = BehaviorRelay<[Category]>(value: [])
    var initialState: State = State()

    init() {
        self.initialState = State(loading: false, categoryList: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return requestCategoryListRx()
        case .viewWillAppear:
            return requestCategoryListRx()
        case .refresh:
            return Observable.concat([
                Observable.just(.setLoading(loading: true)),
                self.requestCategoryListRx(),
                Observable.just(.setLoading(loading: false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCategoryList(let categoryList):
            newState.categoryList = categoryList
        case .setLoading(let loading):
            newState.loading = loading
        }
        return newState
    }
    
    private func requestCategoryListRx() -> Observable<Mutation> {
        let response = Observable<Mutation>.create { observer in

            let provider = MoyaProvider<ChallengeAPI>()
            provider.request(.categoryList) { result in
                switch result {
                case let .success(response):
                    let result = try? response.map([Category].self)
                    observer.onNext(Mutation.setCategoryList(result ?? []))
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
