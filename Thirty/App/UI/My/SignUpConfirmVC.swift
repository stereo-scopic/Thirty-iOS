//
//  SignUpConfirmVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/10/15.
//

import UIKit
import ReactorKit

class SignUpConfirmVC: UIViewController, StoryboardView {
    @IBOutlet weak var signUpCompleteButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    var email: String?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        codeTextField.delegate = self
        self.reactor = SignUpConfirmReactor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(reactor: SignUpConfirmReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: SignUpConfirmReactor) {
        signUpCompleteButton.rx.tap
            .bind {
                self.reactor?.action.onNext(.signUpConfirmTapped(self.email ?? "", self.codeTextField.text ?? ""))
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SignUpConfirmReactor) {
        reactor.state
            .map { $0.signUpConfirmFlag }
            .subscribe(onNext: { flag in
                if flag {
                    guard let welcomePopupVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomePopupVC") as? WelcomePopupVC else { return }
                    welcomePopupVC.modalTransitionStyle = .crossDissolve
                    welcomePopupVC.modalPresentationStyle = .fullScreen
                    self.present(welcomePopupVC, animated: true, completion: nil)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.signUpConfirmMessage ?? "" }
            .subscribe(onNext: { message in
                if !message.isEmpty {
                    self.view.showToast(message: message)
                }
            }).disposed(by: disposeBag)
    }
}

extension SignUpConfirmVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        signUpCompleteButton.isEnabled = !string.isEmpty
        self.signUpCompleteButton.backgroundColor = !string.isEmpty ? UIColor.thirtyBlack : UIColor.gray300
        
        return true
    }
}
