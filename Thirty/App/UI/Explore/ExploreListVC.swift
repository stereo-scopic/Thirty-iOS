//
//  ExploreListVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit
import ReactorKit

class ExploreListVC: UIViewController, StoryboardView {
    typealias Reactor = ExploreListReactor
    var disposeBag = DisposeBag()
    
    let cellId = "ExploreListCell"
    
    @IBOutlet weak var exploreCollectionView: UICollectionView!
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ExploreListReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: ExploreListReactor) {
        // Action ( View -> Reactor )
        // State ( Reactor -> View )
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ExploreListReactor) {
        
    }
    
    private func bindState(_ reactor: ExploreListReactor) {
        reactor.state
            .map { $0.challengeList }
            .bind(to: exploreCollectionView.rx.items(cellIdentifier: ExploreListCell.identifier, cellType: ExploreListCell.self)) { _, item, cell in
                cell.titleLabel.text = item.title
                cell.descriptionLabel.text = item.description
            }
            .disposed(by: disposeBag)
    }
}

class ExploreListCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    static var identifier = "ExploreListCell"
    
    @IBAction func addButtonTouchUpInside(_ sender: Any) {
        self.addButton.isSelected = !self.addButton.isSelected
    }
}
