//
//  CompletedChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/12/21.
//

import UIKit
import ReactorKit

class CompletedChallengeListVC: UIViewController, StoryboardView {
    typealias Reactor = CompletedChallengeListReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = CompletedChallengeListReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: CompletedChallengeListReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: CompletedChallengeListReactor) {
        
    }
    
    private func bindState(_ reactor: CompletedChallengeListReactor) {
        
    }
}

class CompletedChallengeCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier = "CompletedChallengeCell"
}
