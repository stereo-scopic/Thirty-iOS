//
//  ExploreDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit

class ExploreDetailVC: UIViewController {

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
//        self.navigationController?.popViewController(animated: false)
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
