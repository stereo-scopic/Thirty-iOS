//
//  CompleteChallengeDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/12/22.
//

import UIKit
import ReactorKit

class CompletedChallengeDetailVC: UIViewController, StoryboardView {
    typealias Reactor = CompletedChallengeDetailReactor
    var disposeBag = DisposeBag()
    var bucketId: String = ""
//    var selectedBucketAnswer = BucketAnswer(stamp: 0)
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var bucketCollectionView: UICollectionView!
    @IBOutlet weak var bucketCategoryLabel: UILabel!
    @IBOutlet weak var bucketTitleLabel: UILabel!
    @IBOutlet weak var bucketCreatedDateLabel: UILabel!
    @IBOutlet weak var bucketAnswerDateLabel: UILabel!
    @IBOutlet weak var bucketAnswerTitleLabel: UILabel!
    @IBOutlet weak var bucketAnswerDetailLabel: UILabel!
    @IBOutlet weak var bucketAnswerImageView: UIImageView!
    @IBOutlet weak var bucketAnswerUpdatedDateLabel: UILabel!
    @IBOutlet weak var bucketMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = CompletedChallengeDetailReactor()
        
        bucketCollectionView.delegate = self
        bucketCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.reactor?.action.onNext(.selectBucketAnswer(indexPath.row))
            }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.viewWillAppear(bucketId))
    }
    
    func bind(reactor: CompletedChallengeDetailReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: CompletedChallengeDetailReactor) {
        reactor.state
            .map { $0.bucketDetail?.answers ?? [] }
            .bind(to: bucketCollectionView.rx.items(cellIdentifier: ThirtyCell.identifier, cellType: ThirtyCell.self)) { index, item, cell in
                
                cell.number.text = "\(index + 1)"
                
                if (index / 6) % 2 == 0 {
                    cell.view.backgroundColor = index % 2 == 0 ? UIColor.gray50 : UIColor.thirtyBlack
                    cell.number.textColor = index % 2 == 0 ? UIColor.thirtyBlack : UIColor.white
                } else {
                    cell.view.backgroundColor = index % 2 == 0 ? UIColor.thirtyBlack : UIColor.gray50
                    cell.number.textColor = index % 2 == 0 ? UIColor.white : UIColor.thirtyBlack
                }
                cell.bucketAnswerTextView.isHidden = true
                
                if let bucketImage = item.image, !bucketImage.isEmpty {
                    if let imageUrl = URL(string: bucketImage) {
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
                        
                        cell.bucketAnswerTextView.isHidden = false
                        cell.bucketAnswerTextNum.text = "\(index + 1)"
                        cell.bucketAnswerTextAnswer.text = ""
                    } else {
                        cell.badgeImage.image = UIImage()
                        
                        if let detail = item.detail, !detail.isEmpty {
                            cell.number.isHidden = true
                            
                            cell.bucketAnswerTextView.isHidden = false
                            cell.bucketAnswerTextNum.text = "\(index + 1)"
                            cell.bucketAnswerTextAnswer.text = item.detail

                            if cell.view.backgroundColor == UIColor.thirtyBlack {
                                cell.bucketAnswerTextAnswer.textColor = UIColor.white
                            } else {
                                cell.bucketAnswerTextAnswer.textColor = UIColor.thirtyBlack
                            }
                        }
                    }
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bucketDetail }
            .subscribe(onNext: { [weak self] bucketDetail in
                self?.bucketCategoryLabel.text = bucketDetail?.bucket?.challenge.category?.name
                self?.bucketTitleLabel.text = bucketDetail?.bucket?.challenge.title
                self?.bucketCreatedDateLabel.text = "\(bucketDetail?.bucket?.created_at?.iSO8601Date().dateToString().dateYYMMDD() ?? "") ~ \(bucketDetail?.bucket?.updated_at?.iSO8601Date().dateToString().dateYYMMDD() ?? "")"
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.selectedBucketAnswer }
            .subscribe(onNext: { [weak self] bucketAnswer in
                guard let mission = bucketAnswer?.mission, !mission.isEmpty else {
                    self?.bucketAnswerDateLabel.text = ""
                    self?.bucketAnswerTitleLabel.text = ""
                    self?.bucketAnswerDetailLabel.text = ""
                    self?.bucketAnswerUpdatedDateLabel.text = ""
                    self?.bucketAnswerImageView.image = UIImage()
                    
                    // 스크롤 맨 위로
                    let scrollviewTopOffset = CGPoint(x: 0, y: 0)
                    self?.mainScrollView.setContentOffset(scrollviewTopOffset, animated: true)
                    return
                }
                
                self?.bucketAnswerDateLabel.text = "#\(bucketAnswer?.date ?? 0)"
                self?.bucketAnswerTitleLabel.text = bucketAnswer?.mission ?? ""
                self?.bucketAnswerDetailLabel.text = bucketAnswer?.detail
                self?.bucketAnswerUpdatedDateLabel.text = bucketAnswer?.updated_at?.iSO8601Date().dateToString()
                
                if let bucketImageURL = URL(string: bucketAnswer?.image ?? "") {
                    self?.bucketAnswerImageView.kf.setImage(with: bucketImageURL)
                } else {
                    self?.bucketAnswerImageView.image = nil
                }
                
                let scrollviewBottomOffset = CGPoint(x: 0, y: (self?.mainScrollView.contentSize.height)! - (self?.mainScrollView.bounds.height)!)
                self?.mainScrollView.setContentOffset(scrollviewBottomOffset, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: CompletedChallengeDetailReactor) {
        backButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        /// 내보내기 액션 추가 필요
        bucketMoreButton.rx.tap
            .subscribe(onNext: {
                let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let exportAction = UIAlertAction(title: "내보내기", style: .default) { _ in
                    guard let challengeExportVC = self.storyboard?
                            .instantiateViewController(withIdentifier: "ChallengeExportVC") as? ChallengeExportVC else { return }
                    challengeExportVC.bucketId = self.bucketId
                    challengeExportVC.preVC = "CompletedChallengeDetailVC"
                    challengeExportVC.modalTransitionStyle = .crossDissolve
                    challengeExportVC.modalPresentationStyle = .overFullScreen
                    
                    self.present(challengeExportVC, animated: true)
                }
                
                alertVC.addAction(cancelAction)
                alertVC.addAction(exportAction)
                
                self.present(alertVC, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
    }

}

extension CompletedChallengeDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bucketCollectionView {
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
