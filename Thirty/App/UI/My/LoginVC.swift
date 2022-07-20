//
//  LoginVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/04/05.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {
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
    let disposeBag = DisposeBag()
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        signUpButton.rx.tap
            .bind {
                guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC else { return }
                self.navigationController?.pushViewController(signUpVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        findPwdButton.rx.tap
            .bind {
                guard let findPwdVC = self.storyboard?.instantiateViewController(withIdentifier: "FindPwdVC") as? FindPwdVC else { return }
                self.navigationController?.pushViewController(findPwdVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .bind {
                
            }
            .disposed(by: disposeBag)
    }
}
