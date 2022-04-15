//
//  MyNoticeVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/24.
//

import UIKit

class MyNoticeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
}
