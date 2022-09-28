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
    
    @IBOutlet weak var bucketAnswerDate: UILabel!
    @IBOutlet weak var bucketAnswerTitle: UILabel!
    @IBOutlet weak var bucketAnswerDetail: UILabel!
    @IBOutlet weak var bucketAnswerMusic: UILabel!
    @IBOutlet weak var bucketAnswerUpdatedDate: UILabel!
    @IBOutlet weak var bucketAnswerImage: UIImageView!
    
    @IBOutlet weak var bucketAnswerEditButton: UIButton!
    
    typealias Reactor = ChallengeReactor
    var disposeBag = DisposeBag()
    var selectedBucketId: String = ""
    var selectedBucketAnswer = BucketAnswer(stamp: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = ChallengeReactor()
        challengeListCollectionView.delegate = self
        thirtyCollectionView.delegate = self
        
        setThirtyCollectionView()
        setCollectionView()
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
        bucketAnswerEditButton.rx.tap
            .bind {
//                if self.bucketAnswerEditButton.titleLabel?.text == "작성하기" {
                    guard let bucketAnswerEnrollVC = self.storyboard?
                            .instantiateViewController(withIdentifier: "BucketAnswerEnrollVC") as? BucketAnswerEnrollVC else { return }
                    bucketAnswerEnrollVC.bucketId = self.selectedBucketId
                    bucketAnswerEnrollVC.bucketAnswer = self.selectedBucketAnswer
                    self.navigationController?.pushViewController(bucketAnswerEnrollVC, animated: false)
//                } else {
//                    guard let bucketDetailVC = self.storyboard?
//                            .instantiateViewController(withIdentifier: "BucketDetailVC") as? BucketDetailVC else { return }
//                    bucketDetailVC.bucketAnswer = self.selectedBucketAnswer
//                    self.navigationController?.pushViewController(bucketDetailVC, animated: false)
//                }
            }.disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ChallengeReactor) {
        reactor.state
            .map { $0.bucketList }
            .bind(to: challengeListCollectionView.rx.items(cellIdentifier: BucketCell.identifier, cellType: BucketCell.self)) { _, item, cell in
                cell.titleLabel.text = item.challenge.title
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedBucket }
            .subscribe(onNext: { [weak self] bucket in
                self?.challengeCategoryLabel.text = bucket?.challenge.category?.name
                self?.challengeTitleLabel.text = bucket?.challenge.title
                self?.challengeCreatedAtLabel.text = "\(bucket?.challenge.created_at?.iSO8601Date() ?? Date()) ~ing"
                
                self?.selectedBucketId = bucket?.id ?? ""
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedBucketAnswer }
            .subscribe(onNext: { [weak self] bucketAnswer in
                self?.bucketAnswerDate.text = "#\(bucketAnswer?.date ?? 0)"
                self?.bucketAnswerTitle.text = bucketAnswer?.mission ?? ""
                self?.bucketAnswerDetail.text = bucketAnswer?.detail
                self?.bucketAnswerMusic.text = bucketAnswer?.music
                self?.bucketAnswerUpdatedDate.text = bucketAnswer?.updated_at?.iSO8601Date().dateToString()
                
                if let bucketImageURL = URL(string: bucketAnswer?.image ?? "") {
                    self?.bucketAnswerImage.load(url: bucketImageURL)
                } else {
                    self?.bucketAnswerImage.image = nil
                }
                
                self?.selectedBucketAnswer = bucketAnswer ?? BucketAnswer(stamp: 0)
                
                let answered = bucketAnswer?.stamp != 0
                self?.bucketAnswerEditButton.setTitle(answered ? "더보기" : "작성하기", for: .normal)
            }).disposed(by: disposeBag)
    }
    
    func setCollectionView() {
        challengeListCollectionView.rx.modelSelected(Bucket.self)
            .subscribe(onNext: { [weak self] bucket in
                self?.reactor?.action.onNext(.selectBucket(bucket))
            }).disposed(by: disposeBag)
        
        thirtyCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.reactor?.action.onNext(.selectBucketAnswer(indexPath.row))
            }).disposed(by: disposeBag)
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
