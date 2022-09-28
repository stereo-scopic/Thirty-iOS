//
//  BucketLinkPopupVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/27.
//

import UIKit
import RxSwift

class BucketLinkPopupVC: UIViewController {
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind {
                
            }.disposed(by: disposeBag)
    }
}
