//
//  BucketStampPopupVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/03.
//

import UIKit
import RxSwift
import RxRelay

class BucketStampPopupVC: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var stamp1Button: UIButton!
    @IBOutlet weak var stamp2Button: UIButton!
    @IBOutlet weak var stamp3Button: UIButton!
    
    let disposeBag = DisposeBag()
    let selectedStamp = BehaviorRelay<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        closeButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        stamp1Button.rx.tap
            .bind {
                self.selectedStamp.accept(1)
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        stamp2Button.rx.tap
            .bind {
                self.selectedStamp.accept(2)
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        stamp3Button.rx.tap
            .bind {
                self.selectedStamp.accept(3)
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
}
