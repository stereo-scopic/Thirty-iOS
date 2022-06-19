//
//  MyVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/15.
//

import UIKit

class MyVC: UIViewController {

    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var alarmTime: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }

    func setUI() {
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func settingButtonTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MySettingVC") as! MySettingVC
        self.navigationController?.pushViewController(settingVC, animated: false)
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
  
  @IBAction func noticeButtonTouchUpInside(_ sender: Any) {
    let noticeVC = self.storyboard?.instantiateViewController(withIdentifier: "MyNoticeVC") as! MyNoticeVC
    self.navigationController?.pushViewController(noticeVC, animated: false)
  }
}
