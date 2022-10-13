//
//  MyNoticeVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/24.
//

import UIKit
import ReactorKit

class MyNoticeVC: UIViewController, StoryboardView {
    typealias Reactor = MyNoticeReactor
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var annouceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = MyNoticeReactor()
        reactor?.action.onNext(.viewWillAppear)
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    func bind(reactor: MyNoticeReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: MyNoticeReactor) {
        reactor.state
            .map { $0.announcementList ?? [] }
            .bind(to: annouceTableView.rx.items(cellIdentifier: "MyNoticeCell", cellType: MyNoticeCell.self)) { _, item, cell in
                cell.contentLabel.text = item.detail
                cell.dateLabel.text = item.updated_at?.iSO8601Date().dateToString()
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: MyNoticeReactor) {
        
    }
}

class MyNoticeCell: UITableViewCell {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
