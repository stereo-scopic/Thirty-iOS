//
//  WelcomeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/06.
//

import UIKit
import Lottie

class WelcomeVC: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let animationView: AnimationView = .init(name: "welcome_motion")
        loadingView.addSubview(animationView)
        
        animationView.frame = animationView.superview!.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
        
        TokenManager.shared.deleteToken()
    }
    
    @IBAction func nextButtonTouchUpInside(_ sender: Any) {
        let selectChallengeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectChallengeThemeVC") as! SelectChallengeThemeVC
        
        self.navigationController?.pushViewController(selectChallengeVC, animated: false)
    }
    
}
