//
//  MyBadgeVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/17.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MyBadgeVC: UIViewController, StoryboardView {
    @IBOutlet weak var validBadgeCountLabel: UILabel!
    @IBOutlet weak var allBadgeCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    typealias Reactor = MyBadgeReactor
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = MyBadgeReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.setBadgeList)
    }
    
    func bind(reactor: MyBadgeReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: MyBadgeReactor) {
        reactor.state
            .map { $0.badgeList }
            .bind(to: collectionView.rx.items(cellIdentifier: BadgeCell.identifier, cellType: BadgeCell.self)) { _, item, cell in
                cell.titleLabel.text = item.name
                
                if item.isowned {
                    if let imageUrl = URL(string: item.illust ?? "") {
                        cell.img.load(url: imageUrl)
                    }
                } else {
                    cell.img.image = UIImage(named: "badge_default")
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { String($0.allCount) }
            .bind(to: allBadgeCountLabel.rx.text )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { String($0.ownedCount) }
            .bind(to: validBadgeCountLabel.rx.text )
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: MyBadgeReactor) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeCell.identifier, for: indexPath) as? BadgeCell else { return UICollectionViewCell() }
        
        return cell
    }
}

class BadgeCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier = "BadgeCell"
}
