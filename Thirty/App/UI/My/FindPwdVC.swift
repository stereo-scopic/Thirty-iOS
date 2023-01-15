//
//  FindPwdVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/07/20.
//

import UIKit
import RxSwift

class FindPwdVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonActions()
    }

    func setButtonActions() {
        backButton.rx.tap
            .bind {
                self.dismiss(animated: true)
            }.disposed(by: disposeBag)
        
        sendEmailButton.rx.tap
            .bind {
                // API 연결
                self.performSegue(withIdentifier: "sendEmailPopup", sender: self)
            }.disposed(by: disposeBag)
    }
}
