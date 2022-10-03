//
//  BucketDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/28.
//

import UIKit
import RxSwift
import ReactorKit

class BucketDetailVC: UIViewController, StoryboardView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!

    @IBOutlet weak var linkImageView: UIView!
    @IBOutlet weak var linkImage: UIImageView!
    
    @IBOutlet weak var detailImageView: UIView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailTextLabel: UILabel!

    @IBOutlet weak var stampImageView: UIView!
    @IBOutlet weak var stampImage: UIImageView!
    
    typealias Reactor = BucketDetailReactor
    var disposeBag = DisposeBag()
    
    var bucketId: String = ""
    var bucketAnswer: BucketAnswer = BucketAnswer(stamp: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = BucketDetailReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reactor?.action.onNext(.viewWillAppear(bucketId, bucketAnswer.date))
    }
    
    func bind(reactor: BucketDetailReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: BucketDetailReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        editButton.rx.tap
            .bind {
                guard let bucketAnswerEnrollVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "BucketAnswerEnrollVC") as? BucketAnswerEnrollVC else { return }
                bucketAnswerEnrollVC.bucketId = self.bucketId
                bucketAnswerEnrollVC.bucketAnswer = self.bucketAnswer
                bucketAnswerEnrollVC.editFlag = true
                self.navigationController?.pushViewController(bucketAnswerEnrollVC, animated: true)
            }.disposed(by: disposeBag)
        
    }
    
    private func bindState(_ reactor: BucketDetailReactor) {
        reactor.state
            .map { $0.bucketAnswer }
            .subscribe(onNext: { answer in
                if let answerEmpty = answer?.updated_at, !answerEmpty.isEmpty {
                    self.bucketAnswer = answer ?? BucketAnswer(stamp: 0)
                }
                
                self.dateLabel.text = "#\(answer?.date ?? 0)"
                self.titleLabel.text = answer?.mission
                self.detailTextLabel.text = answer?.detail
                self.createdDateLabel.text = answer?.updated_at?.iSO8601Date().dateToString()
                
                if let bucketImage = answer?.image, let bucketImageUrl = URL(string: bucketImage) {
                    self.detailImageView.isHidden = false
                    self.detailImage.load(url: bucketImageUrl)
                } else {
                    self.detailImageView.isHidden = true
                }
                
                if let bucketLink = answer?.music, !bucketLink.isEmpty {
                    self.linkImageView.isHidden = false
                } else {
                    self.linkImageView.isHidden = true
                }
                
                if let stamp = answer?.stamp {
                    self.stampImageView.isHidden = false
                    self.stampImage.image = UIImage(named: "badge_\(stamp)")
                } else {
                    self.stampImageView.isHidden = true
                }
                
            }).disposed(by: disposeBag)
    }
}
