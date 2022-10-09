//
//  SplashVC.swift
//  
//
//  Created by 송하경 on 2022/09/17.
//

import UIKit
import Lottie

class SplashVC: UIViewController {
    @IBOutlet weak var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView: AnimationView = .init(name: "splash_motion")
        loadingView.addSubview(animationView)
        
        animationView.frame = animationView.superview!.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.loopMode = .loop
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let launchedFlag = UserDefaults.standard.bool(forKey: "launched")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            if launchedFlag {
                self.performSegue(withIdentifier: "goMain", sender: self)
            } else {
                self.performSegue(withIdentifier: "goOnboarding", sender: self)
            }
        }
    }
}
