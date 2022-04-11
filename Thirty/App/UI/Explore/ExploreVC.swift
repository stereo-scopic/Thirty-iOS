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
        exploreViewModel.exploreObservable
            .bind(to: exploreTV.rx.items(cellIdentifier: cellId, cellType: ExploreCell.self)) { _, item, cell in
                cell.title.text = item.title
                cell.title_kor.text = item.kor_title
//                cell.backgroundColor =
            }.disposed(by: disposeBag)
     
        exploreTV.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                let exploreListVC = self?.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as! ExploreListVC
                self?.navigationController?.pushViewController(exploreListVC, animated: false)
                
            }).disposed(by: disposeBag)
    }

}

// extension ExploreVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreCell", for: indexPath) as? ExploreCell else {
//            return UITableViewCell()
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as! ExploreListVC
//        self.navigationController?.pushViewController(exploreListVC, animated: false)
//
//    }
// }

class ExploreCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var title_kor: UILabel!
}
