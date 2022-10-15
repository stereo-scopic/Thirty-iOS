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
    var findButtonClicked = false
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var noresultView: UIView!
    @IBOutlet weak var resultNameLabel: UILabel!
    @IBOutlet weak var addFriendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = FindFriendReactor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(reactor: FindFriendReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: FindFriendReactor) {
        reactor.state
            .map { $0.resultUsers }
            .subscribe(onNext: { [weak self] user in
                if let friendId = user?.id, !friendId.isEmpty {
                    self?.noresultView.isHidden = true
                    self?.resultView.isHidden = false
                    self?.resultNameLabel.text = user?.nickname
                    self?.addFriendButton.rx.tap
                        .bind {
                            self?.reactor?.action.onNext(.requestFriend(friendId))
                        }.disposed(by: self!.disposeBag)
                } else {
                    self?.noresultView.isHidden = !(self?.findButtonClicked ?? false)
                    
                    self?.resultView.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: FindFriendReactor) {
        searchButton.rx.tap
            .bind {
                let searchText = self.searchTextField.text
                self.findButtonClicked = true
                reactor.action.onNext(.searchButtonTapped(searchText ?? ""))
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
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
