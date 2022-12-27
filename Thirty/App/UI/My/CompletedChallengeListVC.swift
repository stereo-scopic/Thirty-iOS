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
    
    @IBOutlet weak var backButton: UIButton!
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
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Bucket.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] bucket in
                guard let completedChallengeDetailVC = self?.storyboard?
                        .instantiateViewController(withIdentifier: "CompletedChallengeDetailVC") as? CompletedChallengeDetailVC else { return }
                completedChallengeDetailVC.bucketId = bucket.id
                self?.navigationController?.pushViewController(completedChallengeDetailVC, animated: false)
            }).disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: CompletedChallengeListReactor) {
        reactor.state
            .map { $0.completedChallengeList }
            .bind(to: collectionView.rx.items(cellIdentifier: CompletedChallengeCell.identifier, cellType: CompletedChallengeCell.self)) { _, item, cell in
                cell.titleLabel.text = item.challenge.title
                cell.descriptionLabel.text = item.challenge.description
                
                if let imageUrl = URL(string: item.challenge.thumbnail ?? "") {
                    cell.image.kf.setImage(with: imageUrl)
                }
            }.disposed(by: disposeBag)
    }
}

class CompletedChallengeCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier = "CompletedChallengeCell"
}
