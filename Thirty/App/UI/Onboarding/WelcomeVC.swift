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
    
    override func viewWillDisappear(_ animated: Bool) {
        for v in loadingView.subviews {
            v.removeFromSuperview()
        }
    }
    
    @IBAction func guestButtonTouchUpInside(_ sender: Any) {
        let selectChallengeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectChallengeThemeNewVC") as! SelectChallengeThemeNewVC
        
        self.navigationController?.pushViewController(selectChallengeVC, animated: false)
    }
    
    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        let welcomeLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeLoginVC") as! WelcomeLoginVC
        
        self.navigationController?.pushViewController(welcomeLoginVC, animated: false)
    }
    
    @IBAction func signUpButtonTouchUpInside(_ sender: Any) {
        let welcomeSignUpVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeSignUpVC") as! WelcomeSignUpVC
        
        self.navigationController?.pushViewController(welcomeSignUpVC, animated: false)
    }
}
