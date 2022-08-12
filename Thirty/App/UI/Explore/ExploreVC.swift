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
    
    typealias Reactor = ExploreListReactor

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var exploreTV: UITableView!
    
    var disposeBag = DisposeBag()
    
    let cellId = "ExploreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Reactor.Action.load
//            .bind(to: reactor?.action)
//            .disposed(by: disposeBag)
//        setup()
        self.reactor = ExploreListReactor()
    }
    
//    init(reactor: Reactor) {
//        defer {
//            self.reactor = reactor
//        }
//        super.init(
//    }
    
    func bind(reactor: ExploreListReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ExploreListReactor) {
        button.rx.tap
            .map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(_ reactor: ExploreListReactor) {
        reactor.state
            .map { $0.categoryList }
            .bind(to: exploreTV.rx.items(cellIdentifier: cellId, cellType: ExploreCell.self)) { _, item, cell in
                cell.title.text = item.name
                cell.title_kor.text = item.description
            }.disposed(by: disposeBag)
    }
    
    func setup() {
        let provider = MoyaProvider<ChallengeAPI>()
        provider.request(.categoryList) { result in
            switch result {
            case let .success(response):
                let result = try? response.map([Category].self)
            case let .failure(error):
                print("Explore - CategoryList Error", error.localizedDescription)
            }
        }
        
//        exploreViewModel.categoryObservable
//            .bind(to: exploreTV.rx.items(cellIdentifier: cellId, cellType: ExploreCell.self)) { _, item, cell in
//                cell.title.text = item.name
//                cell.title_kor.text = item.description
//            }.disposed(by: disposeBag)
//
//        exploreTV.rx.itemSelected
//            .subscribe(onNext: { [weak self] _ in
//                let exploreListVC = self?.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as! ExploreListVC
//                self?.navigationController?.pushViewController(exploreListVC, animated: false)
//
//            }).disposed(by: disposeBag)
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
