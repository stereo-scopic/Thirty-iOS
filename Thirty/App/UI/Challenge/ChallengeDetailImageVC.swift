//
//  ChallengeDetailImageVc.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit

class ChallengeDetailImageVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageString = ""
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageStringUrl = URL(string: imageString) {
            imageView.load(url: imageStringUrl)
        }
    }
}
