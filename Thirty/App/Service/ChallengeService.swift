//
//  ChallengeService.swift
//  Thirty
//
//  Created by hakyung on 2022/04/21.
//

import RxSwift

protocol ChallengeServiceType{
    func getCategoryList() -> Single<[Category]>
    func getChallengeList(_ categoryName: String) -> Single<[Challenge]>
}

final class ChallengeService: ChallengeServiceType{
    
    fileprivate let network: Network<ChallengeAPI>
    
    init(network: Network<ChallengeAPI>) {
        self.network = network
    }
    
    func getCategoryList() -> Single<[Category]> {
        <#code#>
    }
    
    func getChallengeList(_ categoryName: String) -> Single<[Challenge]> {
        <#code#>
    }
}
