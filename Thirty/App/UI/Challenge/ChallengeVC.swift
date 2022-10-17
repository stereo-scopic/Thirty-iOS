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
import Kingfisher

class ChallengeVC: UIViewController, StoryboardView {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var challengeCategoryLabel: UILabel!
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var challengeCreatedAtLabel: UILabel!
    @IBOutlet weak var challengeEditButton: UIButton!
    
    @IBOutlet weak var challengeListCollectionView: UICollectionView!
    @IBOutlet weak var thirtyCollectionView: UICollectionView!
    
    @IBOutlet weak var bucketAnswerDate: UILabel!
    @IBOutlet weak var bucketAnswerTitle: UILabel!
    @IBOutlet weak var bucketAnswerDetail: UILabel!
    @IBOutlet weak var bucketAnswerUpdatedDate: UILabel!
    @IBOutlet weak var bucketAnswerImage: UIImageView!
    
    @IBOutlet weak var bucketAnswerEditButton: UIButton!
    @IBOutlet weak var notiButton: UIButton!
    @IBOutlet weak var notiNotReadImage: UIImageView!
    
    @IBOutlet weak var tempExportButton: UIButton!
    
    @IBOutlet weak var noChallengeView: UIView!
    @IBOutlet weak var noChallengeButton: UIButton!
    
    typealias Reactor = ChallengeReactor
    var disposeBag = DisposeBag()
    var selectedBucketId: String = ""
    var selectedBucketAnswer = BucketAnswer(stamp: 0)
    var selectedBucketIndex: IndexPath = IndexPath(row: 0, section: 0)
    var bucketAnswerEnrollFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = ChallengeReactor()
        challengeListCollectionView.delegate = self
        thirtyCollectionView.delegate = self
        
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.viewWillAppear(selectedBucketIndex.row))
    }
    
    func bind(reactor: ChallengeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: ChallengeReactor) {
        bucketAnswerEditButton.rx.tap
            .bind {
//                self.reactor?.action.onNext(.selectBucketAnswer(31))
                self.bucketAnswerEnrollFlag = true
                
                if self.bucketAnswerEditButton.titleLabel?.text == "작성하기" {
                    guard let bucketAnswerEnrollVC = self.storyboard?
                            .instantiateViewController(withIdentifier: "BucketAnswerEnrollVC") as? BucketAnswerEnrollVC else { return }
                    bucketAnswerEnrollVC.bucketId = self.selectedBucketId
                    bucketAnswerEnrollVC.bucketAnswer = self.selectedBucketAnswer
                    bucketAnswerEnrollVC.bucketCompleteFlag
                        .subscribe(onNext: { [weak self] successFlag in
                            if successFlag {
                                guard let challengeCompleteVC = self?.storyboard?
                                        .instantiateViewController(withIdentifier: "ChallengeCompleteVC") as? ChallengeCompleteVC else { return }
                                challengeCompleteVC.bucketId = self?.selectedBucketId ?? ""
                                challengeCompleteVC.modalPresentationStyle = .overFullScreen
                                challengeCompleteVC.modalTransitionStyle = .crossDissolve
                                self?.present(challengeCompleteVC, animated: true, completion: nil)
                            }
                        }).disposed(by: self.disposeBag)
                    self.navigationController?.pushViewController(bucketAnswerEnrollVC, animated: true)
                } else {
                    guard let bucketDetailVC = self.storyboard?
                            .instantiateViewController(withIdentifier: "BucketDetailVC") as? BucketDetailVC else { return }
                    bucketDetailVC.bucketId = self.selectedBucketId
                    bucketDetailVC.bucketAnswer = self.selectedBucketAnswer
                    self.navigationController?.pushViewController(bucketDetailVC, animated: true)
                }
            }.disposed(by: disposeBag)
        
        notiButton.rx.tap
            .bind {
                guard let noticeVC = self.storyboard?.instantiateViewController(withIdentifier: "NoticeVC") as? NoticeVC else { return }
                self.navigationController?.pushViewController(noticeVC, animated: true)
            }.disposed(by: disposeBag)
        
        tempExportButton.rx.tap
            .bind {
                self.tabBarController?.selectedIndex = 1
            }.disposed(by: disposeBag)
        
        noChallengeButton.rx.tap
            .bind {
                self.tabBarController?.selectedIndex = 1
            }.disposed(by: disposeBag)
        
        challengeEditButton.rx.tap
            .bind {
                let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let deleteAllAction = UIAlertAction(title: "챌린지 포기", style: .default) { _ in
                    reactor.action.onNext(.stopChallenge(self.selectedBucketId))
                }
//                let deleteContentAction = UIAlertAction(title: "챌린지 내용 모두 지우기", style: .default) { _ in
//
//                }
                
                alertVC.addAction(cancelAction)
                alertVC.addAction(deleteAllAction)
//                alertVC.addAction(deleteContentAction)
                
                self.present(alertVC, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: ChallengeReactor) {
        reactor.state
            .map { $0.bucketList ?? [] }
            .bind(to: challengeListCollectionView.rx.items(cellIdentifier: BucketCell.identifier, cellType: BucketCell.self)) { index, item, cell in
                cell.titleLabel.text = item.challenge.title
                
                cell.backgroundSelectView.backgroundColor = index == self.selectedBucketIndex.row ? UIColor.black : UIColor.white
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bucketList ?? [] }
            .subscribe(onNext: { bucketList in
                self.noChallengeView.isHidden = !bucketList.isEmpty
                self.scrollView.isScrollEnabled = !bucketList.isEmpty
                if bucketList.isEmpty {
                    // 스크롤 맨 위로
                    let scrollviewTopOffset = CGPoint(x: 0, y: 0)
                    self.scrollView.setContentOffset(scrollviewTopOffset, animated: true)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedBucketDetail?.answers ?? [] }
            .bind(to: thirtyCollectionView.rx.items(cellIdentifier: ThirtyCell.identifier, cellType: ThirtyCell.self)) { index, item, cell in

                cell.number.text = "\(index + 1)"

                if (index / 6) % 2 == 0 {
                    cell.view.backgroundColor = index % 2 == 0 ? UIColor.gray50 : UIColor.thirtyBlack
                    cell.number.textColor = index % 2 == 0 ? UIColor.thirtyBlack : UIColor.white
                } else {
                    cell.view.backgroundColor = index % 2 == 0 ? UIColor.thirtyBlack : UIColor.gray50
                    cell.number.textColor = index % 2 == 0 ? UIColor.white : UIColor.thirtyBlack
                }
                
                if let bucketImage = item.image, !bucketImage.isEmpty {
                    if let imageUrl = URL(string: bucketImage) {
//                        cell.bucketAnswerImage.load(url: imageUrl)
                        cell.bucketAnswerImage.kf.setImage(with: imageUrl)
                        cell.number.isHidden = true
                    } else {
                        cell.bucketAnswerImage.image = UIImage()
                        cell.number.isHidden = false
                    }
                } else {
                    cell.bucketAnswerImage.image = UIImage()
                    cell.number.isHidden = false
                    
                    if let stamp = item.stamp, stamp != 0 {
                        cell.badgeImage.image = UIImage(named: "badge_trans_\(stamp)")
                        cell.number.isHidden = true
                    } else {
                        cell.badgeImage.image = UIImage()
                    }
                }
                
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedBucket }
            .subscribe(onNext: { [weak self] bucket in
                self?.challengeCategoryLabel.text = bucket?.challenge.category?.name
                self?.challengeTitleLabel.text = bucket?.challenge.title
                self?.challengeCreatedAtLabel.text = "\(bucket?.created_at?.iSO8601Date().dateToString().dateYYMMDD() ?? "") ~ing"
                
                self?.selectedBucketId = bucket?.id ?? ""
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedBucketAnswer }
            .subscribe(onNext: { [weak self] bucketAnswer in
                guard let mission = bucketAnswer?.mission, !mission.isEmpty else {
                    self?.bucketAnswerDate.text = ""
                    self?.bucketAnswerTitle.text = ""
                    self?.bucketAnswerDetail.text = ""
                    self?.bucketAnswerUpdatedDate.text = ""
                    self?.bucketAnswerEditButton.isHidden = true
                    self?.bucketAnswerImage.image = UIImage()
                    
                    // 스크롤 맨 위로
                    let scrollviewTopOffset = CGPoint(x: 0, y: 0)
                    self?.scrollView.setContentOffset(scrollviewTopOffset, animated: true)
                    return
                }
                
                self?.bucketAnswerEditButton.isHidden = false
                self?.bucketAnswerDate.text = "#\(bucketAnswer?.date ?? 0)"
                self?.bucketAnswerTitle.text = bucketAnswer?.mission ?? ""
                self?.bucketAnswerDetail.text = bucketAnswer?.detail
                self?.bucketAnswerUpdatedDate.text = bucketAnswer?.updated_at?.iSO8601Date().dateToString()
                
                if let bucketImageURL = URL(string: bucketAnswer?.image ?? "") {
//                    self?.bucketAnswerImage.load(url: bucketImageURL)
                    self?.bucketAnswerImage.kf.setImage(with: bucketImageURL)
                } else {
                    self?.bucketAnswerImage.image = nil
                }
                
                self?.selectedBucketAnswer = bucketAnswer ?? BucketAnswer(stamp: 0)
                
                if let _ = bucketAnswer?.updated_at {
                    self?.bucketAnswerEditButton.setTitle("더보기", for: .normal)
                } else {
                    self?.bucketAnswerEditButton.setTitle("작성하기", for: .normal)
                }
                
                let scrollviewBottomOffset = CGPoint(x: 0, y: (self?.scrollView.contentSize.height)! - (self?.scrollView.bounds.height)!)
                self?.scrollView.setContentOffset(scrollviewBottomOffset, animated: true)
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.unreadNoticeFlag ?? false }
            .subscribe(onNext: { isLeft in
                self.notiNotReadImage.isHidden = !isLeft
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stopChallenge }
            .subscribe(onNext: { flag in
                if flag {
                    self.reactor?.action.onNext(.viewWillAppear(0))
                }
            }).disposed(by: disposeBag)
    }
    
    func setCollectionView() {
//        challengeListCollectionView.rx.modelSelected(Bucket.self)
//            .subscribe(onNext: { [weak self] bucket in
//                self?.reactor?.action.onNext(.selectBucket(bucket))
//            }).disposed(by: disposeBag)
        
        Observable.zip(challengeListCollectionView.rx.modelSelected(Bucket.self), challengeListCollectionView.rx.itemSelected)
            .bind { [weak self] (bucket, indexPath) in
                self?.selectedBucketIndex = indexPath
                self?.reactor?.action.onNext(.selectBucket(bucket))
            }
            .disposed(by: disposeBag)
        
        thirtyCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.reactor?.action.onNext(.selectBucketAnswer(indexPath.row))
            }).disposed(by: disposeBag)
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
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var bucketAnswerImage: UIImageView!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    static var identifier = "ThirtyCell"
    
    override func awakeFromNib() {
    }
    
    override func prepareForReuse() {
        cellWidth.constant = UIScreen.main.bounds.width / 6
        bucketAnswerImage.image = UIImage()
    }
}

class BucketCell: UICollectionViewCell {
    @IBOutlet weak var backgroundSelectView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static var identifier = "BucketCell"
    
    override func prepareForReuse() {
        backgroundSelectView.backgroundColor = UIColor.white
    }
}
