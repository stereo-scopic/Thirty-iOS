//
//  ExploreVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import ReactorKit

class ExploreVC: UIViewController, StoryboardView {
    
    typealias Reactor = ExploreReactor

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var exploreTV: UITableView!
    
    var disposeBag = DisposeBag()
    
    let cellId = "ExploreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ExploreReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: ExploreReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ExploreReactor) {
        button.rx.tap
            .map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        exploreTV.rx.modelSelected(Category.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                if let exploreListVC = self?.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.categoryName = item.name ?? ""
                    self?.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: ExploreReactor) {
        reactor.state
            .map { $0.categoryList }
            .bind(to: exploreTV.rx.items(cellIdentifier: cellId, cellType: ExploreCell.self)) { _, item, cell in
                cell.title.text = item.name
                cell.title_kor.text = item.description
            }.disposed(by: disposeBag)
    }
    
    @IBAction func exploreButtonTouchUpInside(_ sender: Any) {
        if let createChallengeVC = self.storyboard?.instantiateViewController(withIdentifier: "createChallengeVC") as? CreateChallengeVC {        
            self.navigationController?.pushViewController(createChallengeVC, animated: false)
        }
        
    }
}

class ExploreCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var title_kor: UILabel!
}
