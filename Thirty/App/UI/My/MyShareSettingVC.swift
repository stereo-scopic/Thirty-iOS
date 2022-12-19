//
//  MyShareSettingVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class MyShareSettingVC: UIViewController, StoryboardView {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var shareImage: UIImageView!
    
    var disposeBag = DisposeBag()
    typealias Reactor = MyShareSettingReactor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = MyShareSettingReactor()
        slider.setThumbImage(UIImage(named: "share_arrow"), for: .normal)
    }
    
    func bind(reactor: MyShareSettingReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: MyShareSettingReactor) {
        let visibilityValue = UserService.shared.myProfile?.visibility

        slider.value = visibilityValue?.visibilityNum() ?? 0
    }
    
    private func bindAction(_ reactor: MyShareSettingReactor) {
        slider.rx.value
            .subscribe(onNext: { value in
                let roundValue = roundf(value / 1) * 1
                self.shareImage.image = UIImage(named: "share\(roundValue)")
                self.slider.value = roundValue
                
                var visibilityString = ""
                if roundValue == 0 {
                    visibilityString = ShareVisibilityRange.privateRange.rawValue
                } else if roundValue == 1 {
                    visibilityString = ShareVisibilityRange.friendRange.rawValue
                } else if roundValue == 2 {
                    visibilityString = ShareVisibilityRange.publicRange.rawValue
                }
                
                self.reactor?.action.onNext(.changeVisibility(visibilityString))
            }).disposed(by: disposeBag)
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.popVC(animated: false, completion: nil)
    }
    
}

class CustomSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.trackRect(forBounds: bounds)
        rect.size.height = 10
        
        return rect
    }
}
