//
//  MyFriendManageVC.swift
//  Thirty
//
//  Created by hakyung on 2022/11/22.
//

import UIKit
import ReactorKit

class MyFriendManageVC: UIViewController, StoryboardView {
    typealias Reactor = MyFriendManageReactor
    var disposeBag = DisposeBag()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var friendListButton: UIButton!
    @IBOutlet weak var blockListButton: UIButton!
    @IBOutlet weak var friendTableView: UITableView!
    
    var selectedType = "friend"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reactor = MyFriendManageReactor()
        reactor?.action.onNext(.friendButtonTapped)
    }
    
    func bind(reactor: MyFriendManageReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: MyFriendManageReactor) {
        reactor.state
            .map { $0.friendAndBlockUserList ?? [] }
            .bind(to: friendTableView.rx.items(cellIdentifier: MyFriendCell.identifier, cellType: MyFriendCell.self)) { _, item, cell in
                cell.nickname.text = self.selectedType == "friend" ? item.friendNickname :  item.targetUser?.nickname
                
                cell.unblockButton.isHidden = self.selectedType == "friend"
                
                let targetUserId = item.targetUser?.id
                cell.unblockButton.rx.tap
                    .bind {
                        self.reactor?.action.onNext(.unblockUserTapped(targetUserId ?? ""))
                    }.disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.serverMessage ?? "" }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: MyFriendManageReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        friendListButton.rx.tap
            .bind {
                reactor.action.onNext(.friendButtonTapped)
                self.selectedType = "friend"
                self.friendListButton.setTitleColor(.thirtyBlack, for: .normal)
                self.blockListButton.setTitleColor(.blue, for: .normal)
            }.disposed(by: disposeBag)
        
        blockListButton.rx.tap
            .bind {
                reactor.action.onNext(.blockButtonTapped)
                self.selectedType = "block"
                self.friendListButton.setTitleColor(.blue, for: .normal)
                self.blockListButton.setTitleColor(.thirtyBlack, for: .normal)
            }.disposed(by: disposeBag)
    }
}

class MyFriendCell: UITableViewCell {
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    static let identifier = "MyFriendCell"
    
}
