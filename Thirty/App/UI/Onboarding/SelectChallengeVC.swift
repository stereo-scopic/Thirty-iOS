//
//  SelectChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/06.
//

import UIKit

class SelectChallengeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension SelectChallengeVC {
    @IBAction func backButtonTouchUpInside(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}
