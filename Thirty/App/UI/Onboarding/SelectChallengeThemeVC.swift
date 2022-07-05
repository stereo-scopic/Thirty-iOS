//
//  SelectChallengeThemeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/06.
//

import UIKit

class SelectChallengeThemeVC: UIViewController {
    @IBOutlet weak var hobbyButton: UIButton!
    @IBOutlet weak var fanButton: UIButton!
    @IBOutlet weak var loveButton: UIButton!
    @IBOutlet weak var selfCareButton: UIButton!
    @IBOutlet weak var dietButton: UIButton!
    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var studyButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
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
        
        self.navigationController?.pushViewController(selectChallengeVC, animated: false)
    }
    
    @IBAction func hobbyButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        hobbyButton.isSelected = true
    }
    
    @IBAction func fanButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        fanButton.isSelected = true
    }
    
    @IBAction func loveButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        loveButton.isSelected = true
    }
    
    @IBAction func selfcareButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        selfCareButton.isSelected = true
    }
    
    @IBAction func dietButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        dietButton.isSelected = true
    }
    
    @IBAction func studyButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        studyButton.isSelected = true
    }
    
    @IBAction func fitnessButtonTouchUpInside(_ sender: UIButton) {
        disableAllButton()
        fitnessButton.isSelected = true
    }
}
