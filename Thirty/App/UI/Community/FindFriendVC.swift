//
//  FindFriendVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit
import ReactorKit

class FindFriendVC: UIViewController, StoryboardView {
    typealias Reactor = FindFriendReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bind(reactor: FindFriendReactor) {
        bindState(reactor)
        bindAction(reactor)
    }

    private func bindState(_ reactor: FindFriendReactor) {
        reactor.state
            .map { $0.resultUsers ?? [] }
            .bind(to: resultTableView.rx.items(cellIdentifier: FindFriendCell.identifier, cellType: FindFriendCell.self)) { index, item, cell in
                
                cell.userNameLabel.text = item.nickname
                cell.addFriendButton.rx.tap
                    .bind {
                        if let friendId = item.id {
                            self.reactor?.action.onNext(.requestFriend(friendId))
                        }
                    }.disposed(by: self.disposeBag)
                
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: FindFriendReactor) {
        searchButton.rx.tap
            .bind {
                let searchText = self.searchTextField.text
                
                reactor.action.onNext(.searchButtonTapped(searchText ?? ""))
            }.disposed(by: disposeBag)
    }
}

class FindFriendCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    static let identifier = "FindFriendCell"
    
    override func prepareForReuse() {
        
    }
}
