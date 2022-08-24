//
//  SelectChallengeThemeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/06.
//

import UIKit
import RxSwift
import RxRelay

class SelectChallengeThemeVC: UIViewController {
    @IBOutlet weak var hobbyButton: UIButton!
    @IBOutlet weak var fanButton: UIButton!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var selfCareButton: UIButton!
    @IBOutlet weak var dietButton: UIButton!
    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    let selectedItem = BehaviorRelay<String>(value: "")
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hobbyButton.isHighlighted = true
        fanButton.isHighlighted = true
        loveButton.isHighlighted = true
        selfCareButton.isHighlighted = true
        dietButton.isHighlighted = true
        studyButton.isHighlighted = true
        fitnessButton.isHighlighted = true
        
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor.gray800
        nextButton.setTitleColor(UIColor.gray700, for: .normal)
    }
    
    func disableAllButton() {
        hobbyButton.isSelected = false
        fanButton.isSelected = false
        loveButton.isSelected = false
        selfCareButton.isSelected = false
        dietButton.isSelected = false
        studyButton.isSelected = false
        fitnessButton.isSelected = false
        
        hobbyButton.isHighlighted = false
        fanButton.isHighlighted = false
        loveButton.isHighlighted = false
        selfCareButton.isHighlighted = false
        dietButton.isHighlighted = false
        studyButton.isHighlighted = false
        fitnessButton.isHighlighted = false
        
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor.thirtyWhite
        nextButton.setTitleColor(UIColor.black, for: .normal)
    }
}

extension SelectChallengeThemeVC {
    @IBAction func nextButtonTouchUpInside(_ sender: UIButton) {
        let selectChallengeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectChallengeVC") as! SelectChallengeVC
        selectChallengeVC.selectedItem = selectedItem
        
        self.navigationController?.pushViewController(selectChallengeVC, animated: false)
    }
    
    @IBAction func hobbyButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        hobbyButton.isSelected = true
        selectedItem.accept("취미")
    }
    
    @IBAction func fanButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        fanButton.isSelected = true
        selectedItem.accept("덕질")
    }
    
    @IBAction func loveButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        loveButton.isSelected = true
        selectedItem.accept("연애")
    }
    
    @IBAction func selfcareButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        selfCareButton.isSelected = true
        selectedItem.accept("셀프케어")
    }
    
    @IBAction func dietButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        dietButton.isSelected = true
        selectedItem.accept("다이어트")
    }
    
    @IBAction func studyButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        studyButton.isSelected = true
        selectedItem.accept("공부")
    }
    
    @IBAction func fitnessButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        fitnessButton.isSelected = true
        selectedItem.accept("피트니스")
    }
}
