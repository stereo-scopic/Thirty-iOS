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
    
    var disposeBag = DisposeBag()
    typealias Reactor = CommunityReactor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = CommunityReactor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reactor?.action.onNext(.friendCommunityDidAppear)
        
        if let email = UserService.shared.myProfile?.email, !email.isEmpty {
            self.noFriendView.isHidden = true
        } else {
            self.noFriendView.isHidden = false
        }
    }
    
    func bind(reactor: CommunityReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: CommunityReactor) {
        reactor.state
            .map { $0.friendCommunityList ?? [] }
            .bind(to: communityFriendTableView.rx.items(cellIdentifier: CommunityListCell.identifier, cellType: CommunityListCell.self)) { index, item, cell in
                
                cell.nicknameButton.setTitle(item.usernickname, for: .normal)
                cell.challengeTitleLabel.text = item.challenge
                cell.challengeOrderLabel.text = "#\(item.date)"
                cell.challengeNameLabel.text = item.mission
                cell.detailLabel.text = item.detail
                
                let readmoreFont = UIFont(name: "Pretendard-Light", size: 16.0)
                
                if item.isFolded == nil {
                    if let detailText = item.detail, detailText.count > 30 {
                    cell.detailLabel.addTrailing(with: "... ", moreText: "더보기", moreTextFont: readmoreFont!, moreTextColor: .gray400 ?? .black)
                    }
                }
                
                cell.challengeCreatedAtLabel.text = item.created_at?.iSO8601Date().dateToString().dateMMDD()
                
                cell.nicknameClicked = { [weak self] in
                    let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    let deleteAllAction = UIAlertAction(title: "신고하기", style: .default) { _ in
                        reactor.action.onNext(.reportUser(item.userid ?? ""))
                    }
                    let deleteContentAction = UIAlertAction(title: "차단하기", style: .default) { _ in
                        reactor.action.onNext(.blockUser(item.userid ?? ""))
                    }
                    
                    alertVC.addAction(cancelAction)
                    alertVC.addAction(deleteAllAction)
                    alertVC.addAction(deleteContentAction)
                    
                    self?.present(alertVC, animated: true, completion: nil)
                }
                
                if let imageUrl = URL(string: item.image ?? "") {
                    cell.challengeImage.isHidden = false
                    cell.challengeImage.kf.setImage(with: imageUrl)
                } else {
                    cell.challengeImage.isHidden = true
                }
                
                cell.makeExpand = { _ in
                    cell.detailLabel.numberOfLines = 0
                    reactor.action.onNext(.unFoldCell(index))
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.serverMessage ?? "" }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                }
            }).disposed(by: disposeBag)
    }
    
    @objc func nicknameTapped(_ sender: UITapGestureRecognizer) {
        
    }
    
    private func bindAction(_ reactor: CommunityReactor) {
        loginButton.rx.tap
            .bind {
                self.navigationController?.tabBarController?.selectedIndex = 3
            }.disposed(by: disposeBag)
    }
    
}
