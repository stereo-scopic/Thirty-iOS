//
//  ChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/02/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class ChallengeVC: UIViewController, StoryboardView {
    @IBOutlet weak var challengeCategoryLabel: UILabel!
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var challengeCreatedAtLabel: UILabel!
    
    @IBOutlet weak var challengeListCollectionView: UICollectionView!
    @IBOutlet weak var thirtyCollectionView: UICollectionView!
    
    @IBOutlet weak var infoNumber: UILabel!
    @IBOutlet weak var infoTitle: UILabel!
    
//    let viewModel = ChallengeListViewModel()
    typealias Reactor = ChallengeReactor
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = ChallengeReactor()
        challengeListCollectionView.delegate = self
//        challengeListCollectionView.dataSource = self
        
        thirtyCollectionView.delegate = self
//        thirtyCollectionView.dataSource = self
        
        setThirtyCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.viewWillAppear)
    }
    
    func bind(reactor: ChallengeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ChallengeReactor) {
        
    }
    
    private func bindState(_ reactor: ChallengeReactor) {
        reactor.state
            .map { $0.bucketList }
            .bind(to: challengeListCollectionView.rx.items(cellIdentifier: BucketCell.identifier, cellType: BucketCell.self)) { _, item, cell in
                cell.titleLabel.text = item.challenge.title
            }
            .disposed(by: disposeBag)
        
    }
    
    func setCollectionView() {
        challengeListCollectionView.rx.modelSelected(Bucket.self)
            .subscribe(onNext: { [weak self] bucket in
                self?.reactor?.action.onNext(.selectBucket(bucket))
            })
            .disposed(by: disposeBag)
    }
    
    func setThirtyCollectionView() {
        let dayArr = [Int](1...30)
        
        let dataSource = BehaviorSubject<[Int]>(value: dayArr)
        
        dataSource.bind(to: thirtyCollectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirtyCell", for: indexPath) as? ThirtyCell {
                cell.number.text = "\(element)"
                
                if (indexPath.row / 6) % 2 == 0 {
                    cell.view.backgroundColor = indexPath.row % 2 == 0 ? UIColor.gray50 : UIColor.gray200
                } else {
                    cell.view.backgroundColor = indexPath.row % 2 == 0 ? UIColor.gray200 : UIColor.gray50
                }
                
                return cell
            }
            return UICollectionViewCell()
        }.disposed(by: disposeBag)
        
        thirtyCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.infoNumber.text = "#\(index.row + 1)"
            })
            .disposed(by: disposeBag)
        
    }
}

extension ChallengeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == thirtyCollectionView {
            let width: CGFloat = collectionView.bounds.width / 6
            let height: CGFloat = 84
            
            return CGSize(width: width, height: height)
        } else {
            return CGSize(width: 80, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class ThirtyCell: UICollectionViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
    }
}

class BucketCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier = "BucketCell"
    
    override func prepareForReuse() {
        
    }
}
