//
//  ExploreVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit
import RxSwift
import RxCocoa

class ExploreVC: UIViewController {

    @IBOutlet weak var exploreTV: UITableView!
    
    let exploreViewModel = ExploreListViewModel()
    var disposeBag = DisposeBag()
    
    let cellId = "ExploreCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
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
