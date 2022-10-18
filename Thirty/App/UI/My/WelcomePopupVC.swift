//
//  WelcomePopupVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/11.
//

import UIKit

class WelcomePopupVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.presentingViewController?
            .presentingViewController?
            .presentingViewController?
            .dismiss(animated: false, completion: nil)
    }
    
}
