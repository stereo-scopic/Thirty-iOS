//
//  ChallengeExportVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit
import ReactorKit

class ChallengeExportVC: UIViewController, StoryboardView {
    typealias Reactor = ChallengeExportReactor
    var disposeBag = DisposeBag()
    var bucketId = ""

    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewWillAppear(bucketId))
    }
    
    func bind(reactor: ChallengeExportReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: ChallengeExportReactor) {
        
    }
    
    private func bindAction(_ reactor: ChallengeExportReactor) {
        
    }
}
