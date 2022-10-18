//
//  CreateChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/07.
//

import UIKit
import RxSwift

class CreateChallengeVC: UIViewController {
    var buttonEnabled = Observable.just(false)
    var disposeBag = DisposeBag()
    
    var challengeTitleEmpty: Observable<Bool> = Observable.just(true)
    var challengeDescriptionEmpty: Observable<Bool> = Observable.just(true)
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var challengeTitleTextField: UITextField!
    @IBOutlet weak var challengeDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonEnabled
            .subscribe(onNext: { enable in
                self.completeButton.setTitleColor(enable ? UIColor.gray300:  UIColor.thirtyBlack, for: .normal)
            })
            .disposed(by: disposeBag)
        
        challengeTitleEmpty = challengeTitleTextField.rx.text.orEmpty
            .map { $0.isEmpty }
        
        challengeDescriptionEmpty = challengeDescriptionTextField.rx.text.orEmpty
            .map { $0.isEmpty }
        
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func completeButtonTouchUpInside(_ sender: Any) {
        
    }
}
