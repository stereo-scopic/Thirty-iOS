//
//  MyShareSettingVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/24.
//

import UIKit

class MyShareSettingVC: UIViewController {

    @IBOutlet weak var slider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
    }
    
    func updateUI() {
        
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }

}
