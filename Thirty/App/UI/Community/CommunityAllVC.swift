//
//  CommunityAllVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit
import RxSwift
import ReactorKit

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

                cell.nicknameLabel.text = item.nickname
                cell.challengeTitleLabel.text = item.mission
                cell.challengeOrderLabel.text = "#\(item.date)"
                cell.challengeNameLabel.text = item.challenge
                cell.detailLabel.text = item.detail
                cell.challengeCreatedAtLabel.text = item.created_at?.iSO8601Date().dateToString()
//                cell.detailLabel.numberOfLines = 1
                
                cell.addFriendButton.isHidden = item.isFriend ?? true
                    
                cell.addFriend = { _ in
                    // 친구신청API
                }

                if let imageUrl = URL(string: item.image ?? "") {
                    cell.challengeImage.isHidden = false
                    cell.challengeImage.load(url: imageUrl)
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
