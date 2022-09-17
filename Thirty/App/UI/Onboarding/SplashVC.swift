//
//  SplashVC.swift
//  
//
//  Created by 송하경 on 2022/09/17.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let launchedFlag = UserDefaults.standard.bool(forKey: "launched")
        
        if launchedFlag {
            performSegue(withIdentifier: "goMain", sender: self)
        } else {
            performSegue(withIdentifier: "goOnboarding", sender: self)
        }
    }
}
