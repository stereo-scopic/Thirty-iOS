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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI(){
        mainView.topRoundCorner(radius: 20)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func settingButtonTouchUpInside(_ sender: Any) {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "MySettingVC") as! MySettingVC
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
    
    @IBAction func timeButtonTouchUpInside(_ sender: Any) {
        
    }
}
