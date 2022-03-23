//
//  ChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/02/25.
//

import UIKit
import RxSwift
import RxCocoa

class ChallengeVC: UIViewController {
    
    let viewModel = ChallengeListViewModel()
    let disposeBag = DisposeBag.init()
    
    @IBOutlet weak var thirtyCollectionView: UICollectionView!
    
    @IBOutlet weak var infoNumber: UILabel!
    @IBOutlet weak var infoTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thirtyCollectionView.delegate = self
        setThirtyCollectionView()
    }
    
    func setThirtyCollectionView(){
        let dayArr = Array<Int>(1...30)
        
        let dataSource = BehaviorSubject<[Int]>(value: dayArr)
        
        dataSource.bind(to: thirtyCollectionView.rx.items){ (collectionView,row,element) in
            let indexPath = IndexPath(row: row, section: 0)
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThirtyCell", for: indexPath) as? ThirtyCell{
                cell.number.text = "\(element)"
                
                
                if (indexPath.row / 6) % 2 == 0{
                    cell.view.backgroundColor = indexPath.row % 2 == 0 ? UIColor.gray50 : UIColor.gray200
                }else{
                    cell.view.backgroundColor = indexPath.row % 2 == 0 ? UIColor.gray200 : UIColor.gray50
                }
                
                return cell
            }
            return UICollectionViewCell()
        }.disposed(by: disposeBag)
        
        thirtyCollectionView.rx.itemSelected
            .subscribe(onNext:{ [weak self] index in
                self?.infoNumber.text = "#\(index.row + 1)"
            })
            .disposed(by: disposeBag)
        
    }
}

extension ChallengeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width / 6
        let height: CGFloat = 84
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class ThirtyCell: UICollectionViewCell{
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
    }
}
