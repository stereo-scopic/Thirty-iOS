//
//  SettingVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit
import RxSwift
import ReactorKit

class MySettingVC: UIViewController, StoryboardView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var myInfoButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var myShareButton: UIButton!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    @IBOutlet weak var privateInfoButton: UIButton!
    @IBOutlet weak var openSourceButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var withdrawalButton: UIButton!
    
    @IBOutlet weak var appStoreButton: UIButton!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    var disposeBag = DisposeBag()
    typealias Reactor = MySettingReactor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = MySettingReactor()
    }
    
    func bind(reactor: MySettingReactor) {
        bindAction(reactor)
    }
    
    private func bindAction(_ reactor: MySettingReactor) {
        backButton.rx.tap
            .bind {
                self.popVC(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
        
        myInfoButton.rx.tap
            .bind {
                guard let myInfoVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "MyInfoVC") as? MyInfoVC else {
                            return
                        }
                self.navigationController?.pushViewController(myInfoVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        noticeButton.rx.tap
            .bind {
                guard let myAlertVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "MyAlertVC") as? MyAlertVC else {
                            return
                        }
                self.navigationController?.pushViewController(myAlertVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        myShareButton.rx.tap
            .bind {
                guard let myShareSettingVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "MyShareSettingVC") as? MyShareSettingVC else {
                            return
                        }
                self.navigationController?.pushViewController(myShareSettingVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind {
                UserDefaults.standard.set(false, forKey: "launched")
                
                self.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        withdrawalButton.rx.tap
            .bind {
                let withDrawalAlert = UIAlertController(title: nil, message: "정말 써티를 떠나시겠어요?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "탈퇴하기", style: .destructive) { _ in
                    reactor.action.onNext(.withDrawalTapped)
                    UserDefaults.standard.set(false, forKey: "launched")
                    
                    self.dismiss(animated: true, completion: nil)
                }
                withDrawalAlert.addAction(cancelAction)
                withDrawalAlert.addAction(okAction)
                
                self.present(withDrawalAlert, animated: true)
            }
            .disposed(by: disposeBag)
        
        if let dictionary = Bundle.main.infoDictionary,
           let appVersion = dictionary["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = "V \(appVersion)"
        }
        
        privateInfoButton.rx.tap
            .bind {
                if let url = URL(string: privateInfoPageAddress) {
                    UIApplication.shared.open(url, options: [:])
                }
            }.disposed(by: disposeBag)
        
        appStoreButton.rx.tap
            .bind {
                let url = appStoreAddress
                if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }.disposed(by: disposeBag)
    }
}
