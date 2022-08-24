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
    typealias Reactor = ExploreListReactor
    var selectedItem = BehaviorRelay<String>(value: "")
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ExploreListReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: ExploreListReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func bindState(_ reactor: ExploreListReactor) {
        reactor.state
            .map { $0.challengeList }
            .bind(to: collectionView.rx.items(cellIdentifier: OnboardingCollectionViewCell.identifier, cellType: OnboardingCollectionViewCell.self)) { _, item, cell in
                cell.titleButton.setTitle("#\(item.title ?? "")", for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    func bindAction(_ reactor: ExploreListReactor) {
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let text = NSAttributedString(string: reactor?.state.challengeList[indexPath.row] ?? "")
//        return CGSize(width: text.size().width, height: 25)
//    }
}

extension SelectChallengeVC {
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleButton: UIButton!
    
    static var identifier = "OnboardingCollectionViewCell"
}
