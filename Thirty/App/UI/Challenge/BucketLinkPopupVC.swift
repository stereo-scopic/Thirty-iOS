//
//  BucketLinkPopupVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/27.
//

import UIKit
import RxSwift
import RxRelay

class BucketLinkPopupVC: UIViewController {
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    let disposeBag = DisposeBag()
    var inputMusicLink = BehaviorRelay<String>(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind {
                self.inputMusicLink.accept(self.linkTextField.text ?? "")
                self.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
