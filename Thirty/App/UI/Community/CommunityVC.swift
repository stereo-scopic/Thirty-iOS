//
//  CommunityVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit

class CommunityVC: UIViewController {
    var communityTabBarController: CommunityTabBarController?
    @IBOutlet weak var friendButton: UIView!
    @IBOutlet weak var allButton: UIView!
    
    private enum PageType {
        case friend
        case all
    }
    
    private var currentPage: PageType? {
        didSet {
            communityTabBarController?.selectedIndex = self.currentPage == .friend ? 0 : 1
        }
    }
    
    @IBAction func friendButtonTouchUpInside(_ sender: Any) {
        currentPage = .friend
    }
    
    @IBAction func allButtonTouchUpInside(_ sender: Any) {
        currentPage = .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
