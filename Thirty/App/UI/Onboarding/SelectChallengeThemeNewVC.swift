//
//  SelectChallengeThemeNewVC.swift
//  Thirty
//
//  Created by 송하경 on 2023/01/29.
//

import UIKit
import ReactorKit

class SelectChallengeThemeNewVC: UIViewController, StoryboardView {
    typealias Reactor = SelectChallengeThemeNewReactor
    var disposeBag = DisposeBag()
    var selectedCategory: Category?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = SelectChallengeThemeNewReactor()
        reactor?.action.onNext(.viewDidLoad)
        categoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func bind(reactor: SelectChallengeThemeNewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }

    private func bindAction(_ reactor: SelectChallengeThemeNewReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind {
                let selectChallengeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectChallengeVC") as! SelectChallengeVC
                selectChallengeVC.selectedCategory = self.selectedCategory
                
                self.navigationController?.pushViewController(selectChallengeVC, animated: true)
            }.disposed(by: disposeBag)
        
        Observable.zip(categoryCollectionView.rx.modelSelected(Category.self), categoryCollectionView.rx.itemSelected)
            .bind { [weak self] (category, indexPath) in
                self?.nextButton.setTitleColor(.white, for: .normal)
                self?.nextButton.isEnabled = true
                
                self?.categoryCollectionView.visibleCells.forEach {
                    let cell = $0 as! SelectChallengeCollectionViewCell
                    
                    cell.contentView.backgroundColor = .gray700
                    cell.nameEng.textColor = .gray600
                    cell.nameKor.textColor = .gray600
                }
                
                let cell = self?.categoryCollectionView.cellForItem(at: indexPath) as! SelectChallengeCollectionViewCell
                cell.contentView.backgroundColor = .white
                cell.nameEng.textColor = .white
                cell.nameKor.textColor = .white
                
                self?.selectedCategory = category
            }
            .disposed(by: disposeBag)
        
    }
    
    private func bindState(_ reactor: SelectChallengeThemeNewReactor) {
        reactor.state
            .map { $0.categoryList }
            .bind(to: categoryCollectionView.rx.items(cellIdentifier: SelectChallengeCollectionViewCell.identifier, cellType: SelectChallengeCollectionViewCell.self)) { _, item, cell in
                cell.nameKor.text = item.name
                cell.nameEng.text = korNameOfCategory(item.name)
            }
            .disposed(by: disposeBag)
    }
}

extension SelectChallengeThemeNewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 10) / 2
        let height: CGFloat = 89
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

class SelectChallengeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backViewAsBorder: UIView!
    @IBOutlet weak var nameEng: UILabel!
    @IBOutlet weak var nameKor: UILabel!
    
    static var identifier = "SelectChallengeCollectionViewCell"
}
