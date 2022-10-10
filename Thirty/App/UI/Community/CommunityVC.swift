//
//  CommunityVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/29.
//

import UIKit
import RxSwift

class CommunityVC: UIViewController {
    var communityTabBarController: CommunityTabBarController?
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var friendUnderBarView: UIView!
    @IBOutlet weak var allUnderBarView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var findFriendButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    private enum PageType {
        case friend
        case all
    }
    
    private var currentPage: PageType? {
        didSet {
            communityTabBarController?.selectedIndex = self.currentPage == .friend ? 0 : 1
            
            if currentPage == .friend {
                friendButton.setTitleColor(UIColor.thirtyBlack, for: .normal)
                allButton.setTitleColor(UIColor.gray300, for: .normal)
                friendUnderBarView.backgroundColor = UIColor.thirtyBlack
                allUnderBarView.backgroundColor = UIColor.white
            } else {
                friendButton.setTitleColor(UIColor.gray300, for: .normal)
                allButton.setTitleColor(UIColor.thirtyBlack, for: .normal)
                friendUnderBarView.backgroundColor = UIColor.white
                allUnderBarView.backgroundColor = UIColor.thirtyBlack
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tabBarSegue" {
            self.communityTabBarController = segue.destination as? CommunityTabBarController
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
        
        findFriendButton.rx.tap
            .bind {
                guard let findFriendVC = self.storyboard?
                        .instantiateViewController(withIdentifier: "FindFriendVC") as? FindFriendVC else { return }
                self.navigationController?.pushViewController(findFriendVC, animated: false)
            }.disposed(by: disposeBag)
    }
}
