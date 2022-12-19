//
//  MyAppInfoVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/24.
//

import UIKit

class MyAppInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
}
