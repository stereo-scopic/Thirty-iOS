//
//  ExploreVC2.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ExploreVC2: UIViewController {
    @IBOutlet weak var hobbyView: UIView!
    @IBOutlet weak var fanView: UIView!
    @IBOutlet weak var loveView: UIView!
    @IBOutlet weak var selfcareView: UIView!
    @IBOutlet weak var dietView: UIView!
    @IBOutlet weak var fitnessView: UIView!
    @IBOutlet weak var studyView: UIView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
    }
    
    private func bindAction() {
        hobbyView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "취미"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        fanView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "덕질"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        loveView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "연애"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        selfcareView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "셀프케어"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        dietView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "다이어트"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        fitnessView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "피트니스"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        studyView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                if let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC {
                    exploreListVC.selectedTheme = "공부"
                    self.navigationController?.pushViewController(exploreListVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
