//
//  ExploreDetailReactor.swift
//  Thirty
//
//  Created by hakyung on 2022/08/26.
//
import ReactorKit
import Foundation
import RxSwift
import RxCocoa
import Moya

class ExploreDetailReactor: Reactor {
    
    enum Action {
        case load
        case viewWillAppear
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var missionList: [Mission] = []
    }
    
    var initialState: State = State()
}
