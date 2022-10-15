//
//  ChallengeShareViewController.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit

class ChallengeShareVC: UIViewController {
    var challengeImage: UIImage?
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.presentingViewController?
            .presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func shareButtonTouchUpInside(_ sender: Any) {
        guard let image = challengeImage else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func otherChallengeButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true) {
            self.tabBarController?.selectedIndex = 1
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
