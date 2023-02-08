//
//  WelcomeLoginVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/11/05.
//

import UIKit
import ReactorKit

class WelcomeLoginVC: UIViewController, StoryboardView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var findPwdButton: UIButton!
    
    typealias Reactor = WelcomeLoginReactor
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = WelcomeLoginReactor()
    }
    
    func bind(reactor: WelcomeLoginReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: WelcomeLoginReactor) {
        let emailObservable = emailTextField.rx.text
        let pwdObservable = pwdTextField.rx.text
        
        Observable.combineLatest(emailObservable, pwdObservable, resultSelector: { !$0!.isEmpty && !$1!.isEmpty })
            .bind(onNext: { [weak self] isAllEnabled in
                self?.loginButton.backgroundColor = isAllEnabled ? .black : .gray300
                self?.loginButton.isEnabled = isAllEnabled
                
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loginMessage ?? "" }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.loginFlag }
            .subscribe(onNext: { flag in
                if flag {
                    self.performSegue(withIdentifier: "goMain", sender: self)
                    UserDefaults.standard.setValue(true, forKey: "launched")
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: WelcomeLoginReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind {
                self.view.endEditing(true)
                
                let email = self.emailTextField.text ?? ""
                let pwd = self.pwdTextField.text ?? ""
                
                self.reactor?.action.onNext(.loginButtonTapped(email, pwd))
                
            }.disposed(by: disposeBag)
        
        findPwdButton.rx.tap
            .bind {
                guard let findPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "FindPwdVC") as? FindPwdVC else { return }
                findPwdVC.modalTransitionStyle = .crossDissolve
                findPwdVC.modalPresentationStyle = .fullScreen
                self.present(findPwdVC, animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
}
