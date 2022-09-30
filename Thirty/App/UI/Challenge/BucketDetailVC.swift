//
//  BucketDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/28.
//

import UIKit
import RxSwift

class BucketDetailVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!

    @IBOutlet weak var linkImageView: UIView!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var linkImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var detailImageView: UIView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!

    let disposeBag = DisposeBag()
    var bucketAnswer: BucketAnswer = BucketAnswer(stamp: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
    
    func bindState() {
        self.dateLabel.text = "#\(bucketAnswer.date)"
        self.titleLabel.text = bucketAnswer.mission
        self.detailLabel.text = bucketAnswer.detail
        
        if let bucketImage = bucketAnswer.image, let bucketImageUrl = URL(string: bucketImage) {
            self.detailImageView.isHidden = false
            self.detailImage.load(url: bucketImageUrl)
        } else {
            self.detailImageView.isHidden = true
        }
        
        if let bucketLink = bucketAnswer.music {
            self.linkImageView.isHidden = false
            self.linkImageViewHeight.constant = 252
        } else {
            self.linkImageView.isHidden = true
            self.linkImageViewHeight.constant = 0
        }
        
    }
}
