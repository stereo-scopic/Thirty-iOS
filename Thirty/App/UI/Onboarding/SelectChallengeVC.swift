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
    var selectedChallenge: Challenge?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = SelectChallengeReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.setChallengeByTheme(selectedItem.value))
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
    }
    
    func bindAction(_ reactor: SelectChallengeReactor) {
        collectionView.rx.modelSelected(Challenge.self)
            .subscribe(onNext: { challenge in
                print(challenge)
                self.selectedChallenge = challenge
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: {
                reactor.action.onNext(.selectChallenge(self.selectedChallenge?.id ?? 0))
                // response success오면 넘어가도록 처리해야함
                
                self.performSegue(withIdentifier: "goMain", sender: self)
                let viewControllers = self.navigationController?.viewControllers
                self.navigationController?.popToViewController((viewControllers?[viewControllers!.count - 3])!, animated: true)
                UserDefaults.standard.setValue(true, forKey: "launched")
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
