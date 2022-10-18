//
//  CommunityAllVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit
import RxSwift
import ReactorKit
import Kingfisher

class CommunityAllVC: UIViewController, StoryboardView {
    @IBOutlet weak var communityEveryOneTableView: UITableView!
    
    typealias Reactor = CommunityReactor
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = CommunityReactor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reactor?.action.onNext(.allCommunityDidAppear)
    }
    
    func bind(reactor: CommunityReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: CommunityReactor) {
        reactor.state
            .map { $0.allCommunityList ?? [] }
            .bind(to: communityEveryOneTableView.rx.items(cellIdentifier: CommunityListCell.identifier, cellType: CommunityListCell.self)) { _, item, cell in

                cell.nicknameLabel.text = item.usernickname
                cell.challengeTitleLabel.text = item.challenge
                cell.challengeOrderLabel.text = "#\(item.date)"
                cell.challengeNameLabel.text = item.mission
                cell.detailLabel.text = item.detail
                cell.challengeCreatedAtLabel.text = item.created_at?.iSO8601Date().dateToString().dateMMDD()
//                cell.detailLabel.numberOfLines = 1
                
                cell.addFriendButton.isHidden = item.isFriend ?? true
                    
                cell.addFriend = { _ in
                    // 친구신청API
                    self.reactor?.action.onNext(.requestFriend(item.userId ?? ""))
                    cell.addFriendButton.setTitle("추가 완료", for: .normal)
                    cell.addFriendButton.setTitleColor(.thirtyBlack, for: .normal)
                }

                if let imageUrl = URL(string: item.image ?? "") {
                    cell.challengeImage.isHidden = false
//                    cell.challengeImage.load(url: imageUrl)
                    cell.challengeImage.kf.setImage(with: imageUrl)
                } else {
                    cell.challengeImage.isHidden = true
                }

                cell.makeExpand = { [weak self] _ in
                    cell.detailLabel.numberOfLines = 0
                    self?.communityEveryOneTableView.reloadData()
                }

            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: CommunityReactor) {
        
    }
}
