//
//  SettingVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit

class MySettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
    @IBAction func myInfoTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MyInfoVC") as! MyInfoVC
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
    
    @IBAction func myAlertTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAlertVC") as! MyAlertVC
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
    
    @IBAction func myShareSettingTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MyShareSettingVC") as! MyShareSettingVC
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
    
    @IBAction func myNoticeTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MyNoticeVC") as! MyNoticeVC
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
    
    @IBAction func myAppInfoTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MyAppInfoVC") as! MyAppInfoVC
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
}
