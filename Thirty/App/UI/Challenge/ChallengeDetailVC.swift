//
//  ChallengeDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit

class ChallengeDetailVC: UIViewController {
    
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
