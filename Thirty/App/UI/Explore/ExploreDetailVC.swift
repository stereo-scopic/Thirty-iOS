//
//  ExploreDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class ExploreDetailVC: UIViewController, StoryboardView {
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var challengeUserCountLabel: UILabel!
    @IBOutlet weak var challengeDescriptionLabel: UILabel!
    @IBOutlet weak var challengeTableView: UITableView!
    @IBOutlet weak var challengeCollectionView: UICollectionView!
    @IBOutlet weak var challengeAddButton: UIButton!
    
    typealias Reactor = ExploreDetailReactor
    var disposeBag = DisposeBag()
    var categoryName: String = ""
    var challengeId: Int = 0
    var challengeIsOwned: Bool = false
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ExploreDetailReactor(category: categoryName, challengeId: challengeId, challengeIsOwned: challengeIsOwned)
        self.challengeCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: ExploreDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ExploreDetailReactor) {
        challengeAddButton.rx.tap
            .subscribe(onNext: { [weak self] in
                reactor.action.onNext(.addChallengeButtonTapped)
                self?.view.showToast(message: "챌린지가 추가되었어요.")
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ExploreDetailReactor) {
        reactor.state
            .map { $0.challengeDetail.missions ?? [] }
            .bind(to: challengeCollectionView.rx.items(cellIdentifier: ExploreDetailCollectionViewCell.identifier, cellType: ExploreDetailCollectionViewCell.self)) { index, item, cell in
                cell.dateLabel.text = "\(item.date)"
                cell.descriptionLabel.text = item.detail
                
                if (index / 6) % 2 == 0 {
                    cell.backgroundColor = index % 2 == 0 ? UIColor.gray50 : UIColor.gray200
                } else {
                    cell.backgroundColor = index % 2 == 0 ? UIColor.gray200 : UIColor.gray50
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.challengeDetail.missions ?? [] }
            .bind(to: challengeTableView.rx.items(cellIdentifier: ExploreDetailCell.identifier, cellType: ExploreDetailCell.self)) { _, item, cell in
                cell.titleLabel.text = item.detail
                cell.seqLabel.text = "#\(item.date)"
                cell.backgroundColor = UIColor.gray100
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.challengeDetail }
            .subscribe(onNext: { challengeDetail in
                self.challengeTitleLabel.text = challengeDetail.title
                self.challengeDescriptionLabel.text = challengeDetail.description
                self.challengeUserCountLabel.text = "\(challengeDetail.bucketCount ?? 0)명이 이 챌린지를 하고 있어요."
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.challengeIsOwned }
            .subscribe(onNext: { [weak self] isOwned in
                self?.challengeAddButton.backgroundColor = isOwned ? UIColor.gray300 : UIColor.black
                self?.challengeAddButton.setTitle(isOwned ? "추가됨" : "추가하기", for: .normal)
                self?.challengeAddButton.setImage(isOwned ? UIImage(named: "icon_check") : UIImage(), for: .normal)
                self?.challengeAddButton.isEnabled = !isOwned
            })
            .disposed(by: disposeBag)
    }
}

extension ExploreDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width / 6
        let height: CGFloat = 84

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class ExploreDetailCell: UITableViewCell {
    @IBOutlet weak var seqLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier = "ExploreDetailCell"
}

class ExploreDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static var identifier = "ExploreDetailCollectionViewCell"
    
    override class func awakeFromNib() {
        
    }
}
