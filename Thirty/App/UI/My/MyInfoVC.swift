//
//  MyInfoVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/23.
//

import UIKit
import RxSwift

class MyInfoVC: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nickNameButton: UIButton!
    @IBOutlet weak var changePwdButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI() {
        backButton.rx.tap
            .bind {
                self.popVC(animated: false, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
