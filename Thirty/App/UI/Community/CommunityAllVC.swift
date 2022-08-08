//
//  CommunityAllVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit
import RxSwift

class CommunityAllVC: UIViewController {
    @IBOutlet weak var communityEveryOneTableView: UITableView!
    
    let viewModel = CommunityListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.everyoneChallengeObservable
            .bind(to: communityEveryOneTableView.rx.items(cellIdentifier: CommunityListCell.identifier, cellType: CommunityListCell.self)) { _, item, cell in
                
                cell.nicknameLabel.text = item.userNickname
                cell.challengeTitleLabel.text = item.challengeTitle
                cell.challengeOrderLabel.text = "#\(item.challengeOrder + 1)"
                cell.challengeNameLabel.text = item.challengeName
                cell.detailLabel.text = item.challengeDetail
                cell.challengeCreatedAtLabel.text = item.challengeDate
//                cell.detailLabel.numberOfLines = 1
                
                if let image = item.challengeImage {
                    cell.challengeImage.isHidden = false
                    cell.challengeImage.image = image
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
}
