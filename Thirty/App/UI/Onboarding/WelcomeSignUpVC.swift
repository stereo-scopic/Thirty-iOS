//
//  WelcomeSignUpVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/11/05.
//

import UIKit
import ReactorKit

class WelcomeSignUpVC: UIViewController, StoryboardView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailValidImage: UIImageView!
    @IBOutlet weak var pwdValidImage: UIImageView!
    @IBOutlet weak var confirmPwdValidImage: UIImageView!
    
    @IBOutlet weak var pwdInfoLabel: UILabel!
    @IBOutlet weak var confirmPwdInfoLabel: UILabel!
    
    let successImage = UIImage(named: "textfield_success")
    let warningImage = UIImage(named: "textfield_warning")
    
    let emailInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwdInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let confirmPwdInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let nicknameInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    let emailValid: PublishSubject<Bool> = PublishSubject<Bool>()
    let pwdValid: PublishSubject<Bool> = PublishSubject<Bool>()
    var confirmPwdValid: PublishSubject<Bool> = PublishSubject<Bool>()
    let nicknameValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var signUpSuccess: PublishSubject<Bool> = PublishSubject<Bool>()
    var signUpSuccessObservable: Observable<Bool> {
        return signUpSuccess.asObservable()
    }
    
    typealias Reactor = WelcomeSignUpReactor
    var disposeBag = DisposeBag()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reactor = WelcomeSignUpReactor()
        bindOutput()
    }
    
    func bind(reactor: WelcomeSignUpReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: WelcomeSignUpReactor) {
        reactor.state
            .map { $0.signUpMessage ?? "" }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.signUpFlag }
            .subscribe(onNext: { flag in
                if flag {
                    self.performSegue(withIdentifier: "goMain", sender: self)
                    UserDefaults.standard.setValue(true, forKey: "launched")
                }
            }).disposed(by: disposeBag)
        
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
        
        nicknameTextField.rx.text.orEmpty
            .bind(to: nicknameInputText)
            .disposed(by: disposeBag)
        
        nicknameInputText
            .map(nicknameNotEmpty)
            .bind(to: nicknameValid)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: WelcomeSignUpReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: {
                let emailValue = try? self.emailInputText.value()
                let pwd = try? self.pwdInputText.value()
                let nickname = try? self.nicknameInputText.value()
                if let emailValue = emailValue, let pwdValue = pwd, let nickname = nickname {
                    reactor.action.onNext(.signupButtonTapped(emailValue, pwdValue, nickname))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        emailValid.subscribe(onNext: { b in
            self.emailValidImage.image = b ? self.successImage : self.warningImage
            self.emailValidImage.isHidden = false
        }).disposed(by: disposeBag)
        
        pwdValid.subscribe(onNext: { b in
            self.pwdValidImage.image = b ? self.successImage : self.warningImage
            self.pwdValidImage.isHidden = false
            
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(pwdInputText, confirmPwdInputText, resultSelector: { $0 == $1})
            .subscribe(onNext: { b in
                self.confirmPwdValidImage.image = b ? self.successImage : self.warningImage
                self.confirmPwdValidImage.isHidden = b
                self.confirmPwdInfoLabel.isHidden = b
                self.confirmPwdValid.onNext(b)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emailValid, pwdValid, confirmPwdValid, nicknameValid, resultSelector: {$0 && $1 && $2 && $3})
            .subscribe(onNext: { b in
                self.confirmButton.isEnabled = b
                self.confirmButton.backgroundColor = b ? UIColor.thirtyBlack : UIColor.gray300
            })
            .disposed(by: disposeBag)
    }
    
    func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    func checkPwdValid(_ password: String) -> Bool {
        let passwordRegex = "(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&]).{8,20}"
        let passwordTesting = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let verification = passwordTesting.evaluate(with: password)
        pwdInfoLabel.isHidden = verification
        return verification
    }
    
    func nicknameNotEmpty(_ nickname: String) -> Bool {
        return !nickname.isEmpty
    }
}
