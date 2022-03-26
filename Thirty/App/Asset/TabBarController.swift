//
//  TabBarController.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/27.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.unselectedItemTintColor = UIColor.gray300
        tabBar.tintColor = UIColor.thirtyBlack
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
