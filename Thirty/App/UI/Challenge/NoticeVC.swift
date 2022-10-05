//
//  NoticeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit
import ReactorKit

class NoticeVC: UIViewController, StoryboardView {
    typealias Reactor = NoticeReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var noticeTableView: UITableView!
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = NoticeReactor()
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: NoticeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindState(_ reactor: NoticeReactor) {
        reactor.state
            .map { $0.noticeList ?? [] }
            .bind(to: noticeTableView.rx.items(cellIdentifier: "NoticeCell", cellType: NoticeCell.self)) { _, item, cell in
                cell.descriptionLabel.text = item.message
                cell.buttonView.isHidden = item.type != "RR0"
                
                cell.acceptFriendHandler = {
                    reactor.action.onNext(.friendAcceptButtonClicked(item.relatedUserId ?? ""))
                }
                
                cell.refuseFriendHandler = {
                    reactor.action.onNext(.friendRefuseButtonClicked(item.relatedUserId ?? ""))
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: NoticeReactor) {
        
    }
}

class NoticeCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var refuseButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var buttonView: UIView!
    
    var acceptFriendHandler: (() -> Void)?
    var refuseFriendHandler: (() -> Void)?
    
    @IBAction func acceptButtonTouchUpInside(_ sender: Any) {
        if let handler = acceptFriendHandler { handler() }
    }
    
    @IBAction func refuseButtonTouchUpInside(_ sender: Any) {
        if let handler = refuseFriendHandler { handler() }
    }
    
    override func prepareForReuse() {
        
    }
}
