//
//  ExploreVC.swift
//  Thirty
//
//  Created by 송하경 on 2022/09/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class ExploreVC: UIViewController {
    @IBOutlet weak var hobbyView: UIView!
    @IBOutlet weak var fanView: UIView!
    @IBOutlet weak var loveView: UIView!
    @IBOutlet weak var selfcareView: UIView!
    @IBOutlet weak var dietView: UIView!
    @IBOutlet weak var fitnessView: UIView!
    @IBOutlet weak var studyView: UIView!
    @IBOutlet weak var createExploreButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindAction()
    }
    
    private func bindAction() {
        guard let exploreListVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreListVC") as? ExploreListVC else { return }
        
        hobbyView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.hobby
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        fanView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.fan
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        loveView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.love
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        selfcareView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.selfcare
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        dietView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.diet
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        fitnessView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.fitness
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        studyView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                exploreListVC.selectedTheme = CategoryType.study
                self.navigationController?.pushViewController(exploreListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        createExploreButton.rx.tap
            .bind { [weak self] _ in
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CreateChallengeVC") as? CreateChallengeVC else { return }
                self?.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
}
