//
//  MyVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/15.
//

import UIKit
import RxSwift
import ReactorKit

class MyVC: UIViewController, StoryboardView {
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var idCopyButton: UIButton!
    
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var csButton: UIButton!
    
    @IBOutlet weak var myBadgeButton: UIButton!
    
    @IBOutlet weak var completeChallengeCountLabel: UILabel!
    @IBOutlet weak var myBadgeCountLabel: UILabel!
    @IBOutlet weak var friendCountLabel: UILabel!
    
    var alarmTime: Date?
    var disposeBag = DisposeBag()
    typealias Reactor = MyReactor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = MyReactor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reactor?.action.onNext(.getInfo)
    }
    
    func bind(reactor: MyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: MyReactor) {
        loginButton.rx.tap
            .bind {
                guard let loginVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                self.navigationController?.pushViewController(loginVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .bind {
                guard let mysettingVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "MySettingVC") as? MySettingVC else { return }
                self.navigationController?.pushViewController(mysettingVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        alarmSwitch.rx.isOn
            .subscribe(onNext: { isOn in
                print(isOn ? "On": "Off")
            })
            .disposed(by: disposeBag)
        
        noticeButton.rx.tap
            .bind {
                guard let myNoticeVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "MyNoticeVC") as? MyNoticeVC else { return }
                self.navigationController?.pushViewController(myNoticeVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        faqButton.rx.tap
            .bind {
                
            }
            .disposed(by: disposeBag)
        
        myBadgeButton.rx.tap
            .bind {
                guard let myNoticeVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "MyBadgeVC") as? MyBadgeVC else { return }
                self.navigationController?.pushViewController(myNoticeVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        idCopyButton.rx.tap
            .bind {
                UIPasteboard.general.string = self.idLabel.text
            }.disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: MyReactor) {
        reactor.state
            .subscribe(onNext: { state in
                let notLogin = state.userInfo.user.email?.isEmpty ?? true
                
                self.nicknameLabel.text = notLogin ? "나" : state.userInfo.user.nickname
                self.idLabel.text = state.userInfo.user.id
                
                self.completeChallengeCountLabel.text = "\(state.userInfo.completedChallengeCount ?? 0)"
                self.myBadgeCountLabel.text = "\(state.userInfo.rewardCount ?? 0)"
                self.friendCountLabel.text = "\(state.userInfo.relationCount ?? 0)"
                
                self.idLabel.isHidden = notLogin
                self.idCopyButton.isHidden = notLogin
                self.loginButton.isHidden = !notLogin
                
            })
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func timeButtonTouchUpInside(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            
        }
        datePicker.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        
        let dateChooserAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        dateChooserAlert.view.addSubview(datePicker)
        dateChooserAlert.addAction(UIAlertAction(title: "완료", style: .cancel) { _ in
            let timeformatter = DateFormatter()
            timeformatter.dateFormat = "hh:mm"
            
            let ampmformatter = DateFormatter()
            ampmformatter.dateFormat = "a"
            ampmformatter.amSymbol = "오전"
            ampmformatter.pmSymbol = "오후"
            
            let time = timeformatter.string(from: datePicker.date)
            self.timeLabel.text = time
            
            let ampm = ampmformatter.string(from: datePicker.date)
            self.ampmLabel.text = ampm
            
        })
        
        let height: NSLayoutConstraint = NSLayoutConstraint(item: dateChooserAlert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.1, constant: 300)
        dateChooserAlert.view.addConstraint(height)
        
        present(dateChooserAlert, animated: true, completion: nil)
    }
}
