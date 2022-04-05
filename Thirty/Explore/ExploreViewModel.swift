//
//  ExploreViewModel.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import Foundation
import RxSwift
import RxRelay

class ExploreListViewModel {
    var exploreObservable = BehaviorRelay<[Explore]>(value: [])
    
}
