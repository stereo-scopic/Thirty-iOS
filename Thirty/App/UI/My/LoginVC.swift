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
    
    func bind(reactor: LoginReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: LoginReactor) {
        reactor.state
            .map { $0.loginFlag }
            .bind { flag in
                if flag {
                    self.navigationController?.popViewController(animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: LoginReactor) {
        signUpButton.rx.tap
            .bind {
                self.performSegue(withIdentifier: "moveSignUp", sender: self)
            }
            .disposed(by: disposeBag)
        
        findPwdButton.rx.tap
            .bind {
                guard let findPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "FindPwdVC") as? FindPwdVC else { return }
                self.navigationController?.pushViewController(findPwdVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind {
                if let email = self.emailTextField.text,
                   let pwd = self.pwdTextField.text,
                   !email.isEmpty,
                   !pwd.isEmpty {
                    reactor.action.onNext(.loginButtonTapped(email, pwd))
                }
                
            }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let signUpVC = segue.destination as? SignUpVC else {
            fatalError()
        }
        
        signUpVC.signUpSuccessObservable
            .subscribe(onNext: { flag in
                if flag {
                    guard let welcomePopupVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePopupVC") as? WelcomePopupVC else { return }
                    welcomePopupVC.modalPresentationStyle = .fullScreen
                    welcomePopupVC.modalTransitionStyle = .crossDissolve
                    self.present(welcomePopupVC, animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        
        kakaoLoginButton.rx.tap
            .bind {
                
            }
            .disposed(by: disposeBag)
    }
}
