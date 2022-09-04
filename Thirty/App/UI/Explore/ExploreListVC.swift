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

class ExploreListVC: UIViewController, StoryboardView {
    typealias Reactor = ExploreListReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    var selectedTheme = ""
//    var categoryName = ""
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ExploreListReactor()
        navigationTitleLabel.text = selectedTheme
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.setChallengeByTheme(selectedTheme))
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
                    exploreDetailVC.categoryName = self?.selectedTheme ?? ""
                    exploreDetailVC.challengeId = item.id ?? 0
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
            }
            .disposed(by: disposeBag)
    }
}

class ExploreListCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    static var identifier = "ExploreListCell"
    
    @IBAction func addButtonTouchUpInside(_ sender: Any) {
        self.addButton.isSelected = !self.addButton.isSelected
    }
}
