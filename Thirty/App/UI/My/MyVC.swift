//
//  MyVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/15.
//

import UIKit
import RxSwift

class MyVC: UIViewController {
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var csButton: UIButton!
    
    var alarmTime: Date?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func timeButtonTouchUpInside(_ sender: Any) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
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
