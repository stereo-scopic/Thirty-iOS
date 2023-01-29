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
    var selectedCategory: Category?
    var disposeBag = DisposeBag()
    var selectedChallenge: Challenge?
    var challgeList: [Challenge]?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = SelectChallengeReactor()
        collectionView.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.setChallengeByTheme(selectedCategory?.name ?? ""))
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
        
        reactor.state
            .map { $0.challengeList.first }
            .subscribe(onNext: { challenge in
                self.selectedChallenge = challenge
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.challengeList }
            .subscribe(onNext: { challengeList in
                self.challgeList = challengeList
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.addChallengeResponse }
            .subscribe(onNext: { responseSucceed in
                if responseSucceed {
                    self.performSegue(withIdentifier: "goMain", sender: self)
                    let viewControllers = self.navigationController?.viewControllers
                    self.navigationController?.popToViewController((viewControllers?[viewControllers!.count - 3])!, animated: true)
                    UserDefaults.standard.setValue(true, forKey: "launched")
                }
            }).disposed(by: disposeBag)
    }
    
    func bindAction(_ reactor: SelectChallengeReactor) {
        collectionView.rx.modelSelected(Challenge.self)
            .subscribe(onNext: { challenge in
                self.selectedChallenge = challenge
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.collectionView.visibleCells.forEach {
                    let onboardingCell = $0 as! OnboardingCollectionViewCell
                    onboardingCell.contentView.backgroundColor = .gray800
                }
                
                let cell = self?.collectionView.cellForItem(at: indexPath) as! OnboardingCollectionViewCell
                cell.contentView.backgroundColor = .white
            }).disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: {
                reactor.action.onNext(.selectChallenge(self.selectedChallenge?.id ?? 0))
            })
            .disposed(by: disposeBag)
    }
}

extension SelectChallengeVC {
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    static var identifier = "OnboardingCollectionViewCell"
}
