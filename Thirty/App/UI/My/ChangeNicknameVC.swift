//
//  ChangeNicknameVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/09.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit

class ChangeNicknameVC: UIViewController, StoryboardView {
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var changeNicknameButton: UIButton!
    
    typealias Reactor = ChangeNicknameReactor
    var disposeBag = DisposeBag()
    let nicknameInputText: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = ChangeNicknameReactor()
    }
    
    func bind(reactor: Reactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindState(_ reactor: ChangeNicknameReactor) {
        nicknameTF.rx.text.orEmpty
            .bind(to: nicknameInputText)
            .disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: ChangeNicknameReactor) {
        changeNicknameButton.rx.tap
            .subscribe(onNext: {
                let nickname = try? self.nicknameInputText.value()
                reactor.action.onNext(.changeNicknameButtonTapped(nickname ?? ""))
                UserService.shared.getProfile()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
