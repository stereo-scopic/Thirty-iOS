//
//  ChallengeListViewModel.swift
//  Thirty
//
//  Created by hakyung on 2022/02/25.
//

import Foundation
import RxSwift
import RxCocoa

class ChallengeListViewModel {
    var challengeObservable = BehaviorRelay<[ChallengeAnswer]>(value: [])
    
    init() {
        
    }
    
}
