//
//  MyInfoVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/23.
//

import UIKit
import RxSwift

class MyInfoVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var changePwdButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        if let userEmail = UserService.shared.myProfile?.email, !userEmail.isEmpty {
            emailLabel.text = userEmail
        } else {
            emailLabel.text = "연동된 이메일이 없습니다."
            emailLabel.textColor = UIColor.gray300
        }
        
        nicknameLabel.text = UserService.shared.myProfile?.nickname
        
        nickNameButton.rx.tap
            .bind {
                guard let changeNicknameVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "ChangeNicknameVC") as? ChangeNicknameVC else { return }
                self.navigationController?.pushViewController(changeNicknameVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        changePwdButton.rx.tap
            .bind {
                guard let sendEmailPopupVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "SendEmailPopupVC") as? SendEmailPopupVC else { return }
                sendEmailPopupVC.modalTransitionStyle = .crossDissolve
                sendEmailPopupVC.modalPresentationStyle = .overFullScreen
                self.present(sendEmailPopupVC, animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
