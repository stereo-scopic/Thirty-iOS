//
//  SelectChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/06.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class SelectChallengeVC: UIViewController, StoryboardView {
    typealias Reactor = SelectChallengeReactor
    var selectedItem = BehaviorRelay<String>(value: "")
    var disposeBag = DisposeBag()
//    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var selectedIndexPath = PublishSubject<IndexPath>()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = SelectChallengeReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: SelectChallengeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindState(_ reactor: SelectChallengeReactor) {
        reactor.state
            .map { $0.challengeList }
            .bind(to: collectionView.rx.items(cellIdentifier: OnboardingCollectionViewCell.identifier, cellType: OnboardingCollectionViewCell.self)) { _, item, cell in
                cell.titleLabel.text = "#\(item.title ?? "")"
            }
            .disposed(by: disposeBag)
        
//        collectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
//        selectedIndexPath
//            .bind(to: collectionView.rx.items(cellIdentifier: OnboardingCollectionViewCell.identifier, cellType: OnboardingCollectionViewCell.self)) { index, item, cell in
//
//                if index == item {
//                    cell.titleLabel.backgroundColor = UIColor.red
//                } else {
//                    cell.titleLabel.backgroundColor = UIColor.blue
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    func bindAction(_ reactor: SelectChallengeReactor) {
        collectionView.rx.itemSelected
            .subscribe(onNext: { _ in
//                Reactor.Action.selectChallenge
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Challenge.self)
            .subscribe(onNext: { challenge in
                print(challenge)

            })
            .disposed(by: disposeBag)
    }
}

extension SelectChallengeVC {
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier = "OnboardingCollectionViewCell"
}
