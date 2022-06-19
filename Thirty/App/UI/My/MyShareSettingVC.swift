//
//  MyShareSettingVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/03/24.
//

import UIKit
import RxSwift
import RxCocoa

class MyShareSettingVC: UIViewController {
  
  @IBOutlet weak var slider: UISlider!
  @IBOutlet weak var shareImage: UIImageView!
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sliderEvent()
  }
  
  func sliderEvent() {
    slider.rx.value
      .subscribe(onNext: { value in
        let roundValue = roundf(value / 1) * 1
        self.shareImage.image = UIImage(named: "share\(roundValue)")
        self.slider.value = roundValue
      }).disposed(by: disposeBag)
    
  }
  
  @IBAction func backButtonTouchUpInside(_ sender: Any) {
    self.popVC(animated: false, completion: nil)
  }
  
}
