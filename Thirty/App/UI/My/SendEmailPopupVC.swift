//
//  SendEmailPopupVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/14.
//

import UIKit

class SendEmailPopupVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.presentingViewController?
            .presentingViewController?.dismiss(animated: false, completion: nil)
    }
}
