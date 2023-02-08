//
//  SelectChallengeThemeNewReactor.swift
//  Thirty
//
//  Created by 송하경 on 2023/01/29.
//

import ReactorKit
import Moya
import RxRelay

class SelectChallengeThemeNewReactor: Reactor {
    enum Action {
        case viewDidLoad
        case selectCategory(Int)
    }
    
    enum Mutation {
        case setCategoryList([Category])
        case selectedCategory(Int)
    }
    
    struct State {
        var categoryList: [Category] = []
        var selectedCategory: Category?
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return requestCategoryListRx()
        case let .selectCategory(index):
            return Observable.just(.selectedCategory(index))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setCategoryList(categoryList):
            newState.categoryList = categoryList
        case let .selectedCategory(index):
            newState.selectedCategory = newState.categoryList[index]
            print("인덱스22", index)
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
                    observer.onNext(.setCategoryList(result ?? []))
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
