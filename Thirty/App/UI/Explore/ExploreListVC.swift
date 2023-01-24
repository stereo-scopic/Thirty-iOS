//
//  ExploreListVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import Kingfisher

class ExploreListVC: UIViewController, StoryboardView {
    typealias Reactor = ExploreListReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    var selectedTheme: CategoryType?
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ExploreListReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let selectedTheme = selectedTheme else {
            return
        }

        reactor?.action.onNext(.setChallengeByTheme(selectedTheme.rawValue))
        navigationTitleLabel.text = selectedTheme.rawValue
    }

    func bind(reactor: ExploreListReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ExploreListReactor) {
        exploreCollectionView.rx.modelSelected(Challenge.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                if let exploreDetailVC = self?.storyboard?.instantiateViewController(withIdentifier: "ExploreDetailVC") as? ExploreDetailVC {
                    exploreDetailVC.categoryName = self?.selectedTheme?.rawValue ?? ""
                    exploreDetailVC.challengeId = item.id ?? 0
                    exploreDetailVC.challengeIsOwned = item.isUserOwned ??  false
                    self?.navigationController?.pushViewController(exploreDetailVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ExploreListReactor) {
        reactor.state
            .map { $0.challengeList }
            .bind(to: exploreCollectionView.rx.items(cellIdentifier: ExploreListCell.identifier, cellType: ExploreListCell.self)) { _, item, cell in
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
                cell.addButton.isSelected = item.isUserOwned ?? false
                cell.addButtonClicked = { _ in
                    reactor.action.onNext(.addChallenge(item.id ?? 0))
                }
                
                let imageUrl = URL(string: item.thumbnail ?? "")
                cell.img.kf.setImage(with: imageUrl!)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.addChallengeMessage }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                    // 목록 갱신
                    if let selectedTheme = self.selectedTheme {
                        reactor.action.onNext(.setChallengeByTheme(selectedTheme.rawValue))
                    }
                }
            }).disposed(by: disposeBag)
    }
}

class ExploreListCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var addButtonClicked: ((Bool) -> Void)?
    
    static var identifier = "ExploreListCell"
    var selectedFlag = false
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
//        self.addButton.isSelected = !sender.isSelected
        selectedFlag = true
        if let handler = addButtonClicked {
            handler(self.addButton.isSelected)
        }
    }
}
