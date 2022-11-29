//
//  MyFriendListVC.swift
//  Thirty
//
//  Created by hakyung on 2022/10/13.
//

import UIKit
import ReactorKit

class MyFriendListVC: UIViewController, StoryboardView {
    typealias Reactor = MyFriendListReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var friendListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reactor = MyFriendListReactor()
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: MyFriendListReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: MyFriendListReactor) {
        reactor.state
            .map { $0.friendList ?? [] }
            .bind(to: friendListTableView.rx.items(cellIdentifier: MyFriendCell.identifier, cellType: MyFriendCell.self)) { _, _, _ in
//                cell.friendNicknameLabel.text = item.friendNickname
//                cell.deletefriendButton.rx.tap
//                    .bind {
//                        self.reactor?.action.onNext(.deleteFriend(item.friendId ?? ""))
//                    }.disposed(by: self.disposeBag)
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: MyFriendListReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}

// class MyFriendCell: UITableViewCell {
//    @IBOutlet weak var friendNicknameLabel: UILabel!
//    @IBOutlet weak var deletefriendButton: UIButton!
//    
//    static let identifier = "MyFriendCell"
// }
