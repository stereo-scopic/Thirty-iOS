//
//  LoginVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UINavigationController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let emailInputText: BehaviorSubject<String> = BehaviorSubject(value:"")
    let pwdInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
    }
    
    @IBAction func signInButtonTouchUpInside(_ sender: Any) {
    }
    
    @IBAction func findPwdButtonTouchUpInside(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
