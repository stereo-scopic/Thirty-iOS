//
//  WelcomeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/06.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonTouchUpInside(_ sender: Any) {
        let selectChallengeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectChallengeThemeVC") as! SelectChallengeThemeVC
        
        self.navigationController?.pushViewController(selectChallengeVC, animated: false)
    }
    
}
