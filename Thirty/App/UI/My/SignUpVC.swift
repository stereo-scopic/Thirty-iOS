//
//  SignUpVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UINavigationController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    
    @IBOutlet weak var emailValidImage: UIImageView!
    @IBOutlet weak var pwdValidImage: UIImageView!
    @IBOutlet weak var confirmPwdValidImage: UIImageView!
    
    @IBOutlet weak var pwdInfoLabel: UILabel!
    @IBOutlet weak var confirmPwdInfoLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    let successImage = UIImage(named: "textfield_success")
    let warningImage = UIImage(named: "textfield_warning")
    
    let emailInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwdInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let confirmPwdInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    let emailValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwdValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let confirmPwdValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var disposeBag = DisposeBag()
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        emailTextField.rx.text.orEmpty
            .bind(to: emailInputText)
            .disposed(by: disposeBag)
        
        emailInputText
            .map(checkEmailValid)
            .bind(to: emailValid)
            .disposed(by: disposeBag)
        
        pwdTextField.rx.text.orEmpty
            .bind(to: pwdInputText)
            .disposed(by: disposeBag)
        
        pwdInputText
            .map(checkPwdValid)
            .bind(to: pwdValid)
            .disposed(by: disposeBag)
        
        confirmPwdTextField.rx.text.orEmpty
            .bind(to: confirmPwdInputText)
            .disposed(by: disposeBag)
        
        confirmPwdInputText
            .map(checkConfirmPwdValid)
            .bind(to: confirmPwdValid)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        emailValid.subscribe(onNext: { b in self.emailValidImage.image = b ? self.successImage : self.warningImage })
            .disposed(by: disposeBag)
        
        pwdValid.subscribe(onNext: { b in self.pwdValidImage.image = b ? self.successImage : self.warningImage })
            .disposed(by: disposeBag)
        
        confirmPwdValid.subscribe(onNext: { b in self.confirmPwdValidImage.image = b ? self.successImage : self.warningImage })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emailValid, pwdValid, confirmPwdValid, resultSelector: {$0 && $1 && $2})
            .subscribe(onNext: { b in self.signUpButton.isEnabled = b })
            .disposed(by: disposeBag)
    }
    
    func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    func checkPwdValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.\\d)(?=.*[$@$!%?&])(?=.*[0-9])[A-Za-z\\d$@$!%*?&]{8}"
        let passwordTesting = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTesting.evaluate(with: password)
    }
    
    func checkConfirmPwdValid(_ confirmPwd: String) -> Bool {
        _ = pwdInputText.subscribe(onNext: { v in
            let boolValue = v == confirmPwd
//            return boolValue
        })
        return true
    }
}
