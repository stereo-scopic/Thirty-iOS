//
//  MyBadgeDetailVC.swift
//  Thirty
//
//  Created by hakyung on 2022/10/13.
//

import UIKit
import RxSwift

class MyBadgeDetailVC: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var badgeInfo: Badge?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.rx.tap
            .bind {
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        if let imageIllust = badgeInfo?.illust {
            let imageURL = URL(string: imageIllust)!
            badgeImageView.load(url: imageURL)
        }
        
        nameLabel.text = badgeInfo?.name
        descriptionLabel.text = badgeInfo?.description
    }
    
}
