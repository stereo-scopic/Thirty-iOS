//
//  LoginVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class LoginVC: UIViewController, StoryboardView {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var naverLoginButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var findPwdButton: UIButton!
    
    let emailInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwdInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    var disposeBag = DisposeBag()
    typealias Reactor = LoginReactor
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = LoginReactor()
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(reactor: LoginReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: LoginReactor) {
        reactor.state
            .map { $0.loginFlag }
            .bind { flag in
                if flag {
                    self.dismiss(animated: true, completion: nil)
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loginMessage ?? "" }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: LoginReactor) {
        signUpButton.rx.tap
            .bind {
                guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else { return }
                signUpVC.modalTransitionStyle = .crossDissolve
                signUpVC.modalPresentationStyle = .fullScreen
                self.present(signUpVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        findPwdButton.rx.tap
            .bind {
                guard let findPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "FindPwdVC") as? FindPwdVC else { return }
                findPwdVC.modalTransitionStyle = .crossDissolve
                findPwdVC.modalPresentationStyle = .fullScreen
                self.present(findPwdVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind {
                self.view.endEditing(true)
                if let email = self.emailTextField.text,
                   let pwd = self.pwdTextField.text,
                   !email.isEmpty,
                   !pwd.isEmpty {
                    reactor.action.onNext(.loginButtonTapped(email, pwd))
                }
                
            }.disposed(by: disposeBag)
    }
    
    func setupUI() {
        kakaoLoginButton.rx.tap
            .bind {
                
            }
            .disposed(by: disposeBag)
    }
}
