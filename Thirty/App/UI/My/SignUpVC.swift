//
//  SignUpVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class SignUpVC: UIViewController, StoryboardView {
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
    
    let emailValid: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    let pwdValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var confirmPwdValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var signUpSuccess: PublishSubject<Bool> = PublishSubject<Bool>()
    var signUpSuccessObservable: Observable<Bool> {
        return signUpSuccess.asObservable()
    }
    
    var disposeBag = DisposeBag()
    typealias Reactor = SignUpReactor
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.reactor = SignUpReactor()
        bindInput()
        bindOutput()
    }
    
    func bind(reactor: SignUpReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SignUpReactor) {
        signUpButton.rx.tap
            .subscribe(onNext: {
                let emailValue = try? self.emailInputText.value()
                let pwd = try? self.pwdInputText.value()
                if let emailValue = emailValue, let pwdValue = pwd {
                    reactor.action.onNext(.signupButtonTapped(emailValue, pwdValue, pwdValue))
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SignUpReactor) {
        reactor.state
            .map { $0.signUpFlag }
//            .bind(to: { flag in
//                signUpSuccess.onNext(flag)
//            })
            .subscribe(onNext: { flag in
                if flag {
                    self.dismiss(animated: true, completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.signUpSuccess.onNext(flag)
                        }
                    })
                }
            })
            .disposed(by: disposeBag)
        
//        signUpSuccess
//            .subscribe(onNext: { flag in
//                if flag {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
//            .disposed(by: disposeBag)
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
                self.confirmPwdValidImage.isHidden = false
                self.confirmPwdInfoLabel.isHidden = b
                self.confirmPwdValid.onNext(b)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emailValid, pwdValid, confirmPwdValid, resultSelector: {$0 && $1 && $2})
            .subscribe(onNext: { b in
                self.signUpButton.isEnabled = b
                self.signUpButton.backgroundColor = b ? UIColor.thirtyBlack : UIColor.gray300
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
}
