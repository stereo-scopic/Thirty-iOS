//
//  CompleteChallengeDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/12/22.
//

import UIKit
import ReactorKit

class CompletedChallengeDetailVC: UIViewController, StoryboardView {
    typealias Reactor = CompletedChallengeDetailReactor
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reactor = CompletedChallengeDetailReactor()
    }
    
    func bind(reactor: CompletedChallengeDetailReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: CompletedChallengeDetailReactor) {
        
    }
    
    private func bindAction(_ reactor: CompletedChallengeDetailReactor) {
        
    }

}
