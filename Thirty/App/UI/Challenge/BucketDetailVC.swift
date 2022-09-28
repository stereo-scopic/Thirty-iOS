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
    
    let disposeBag = DisposeBag()
    var bucketAnswer: BucketAnswer = BucketAnswer(stamp: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
    }
}
