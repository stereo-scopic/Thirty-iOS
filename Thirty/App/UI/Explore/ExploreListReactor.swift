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
        return Observable.create { observer in
            let dummyCategoryList = [
                Category(category_id: 0, name: "자기계발", description: "눈누누누"),
                Category(category_id: 1, name: "취미", description: "눈누누누"),
                Category(category_id: 2, name: "힐링", description: "눈누누누"),
                Category(category_id: 3, name: "피트니스", description: "눈누누누")
            ].shuffled()
            
            observer.onNext(Mutation.setCategoryList(dummyCategoryList))
            observer.onCompleted()
            return Disposables.create()
        }.delay(.seconds(1), scheduler: MainScheduler.instance)
        
//        let provider = MoyaProvider<ChallengeAPI>()
//        provider.request(.categoryList) { result in
//            switch result {
//            case let .success(response):
//                let result = try? response.map([Category].self)
//            case let .failure(error):
//                print("Explore - CategoryList Error", error.localizedDescription)
//            }
//        }
    }
}
