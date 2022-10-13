//
//  CommunityFriendVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit
import RxSwift
import ReactorKit

class CommunityFriendVC: UIViewController, StoryboardView {
    @IBOutlet weak var communityFriendTableView: UITableView!
    @IBOutlet weak var noFriendView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = CommunityListViewModel()
    var disposeBag = DisposeBag()
    typealias Reactor = CommunityReactor

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reactor = CommunityReactor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reactor?.action.onNext(.friendCommunityDidAppear)
    }
    
    func bind(reactor: CommunityReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: CommunityReactor) {
        reactor.state
            .map { $0.friendCommunityList ?? [] }
            .bind(to: communityFriendTableView.rx.items(cellIdentifier: CommunityListCell.identifier, cellType: CommunityListCell.self)) { _, item, cell in

                cell.nicknameLabel.text = item.usernickname
                cell.challengeTitleLabel.text = item.challenge
                cell.challengeOrderLabel.text = "#\(item.date)"
                cell.challengeNameLabel.text = item.mission
                cell.detailLabel.text = item.detail
                cell.challengeCreatedAtLabel.text = item.created_at?.iSO8601Date().dateToString()
//                cell.detailLabel.numberOfLines = 1
                cell.addFriend = { _ in
                    
                }

                if let imageUrl = URL(string: item.image ?? "") {
                    cell.challengeImage.isHidden = false
                    cell.challengeImage.load(url: imageUrl)
                } else {
                    cell.challengeImage.isHidden = true
                }

                cell.makeExpand = { [weak self] _ in
                    cell.detailLabel.numberOfLines = 0
                    self?.communityFriendTableView.reloadData()
                }

            }
            .disposed(by: disposeBag)
        
        if let email = UserService.shared.myProfile?.email, !email.isEmpty {
            self.noFriendView.isHidden = true
        }
    }
    
    private func bindAction(_ reactor: CommunityReactor) {
        loginButton.rx.tap
            .bind {
                self.navigationController?.tabBarController?.selectedIndex = 3
            }.disposed(by: disposeBag)
    }
    
}
