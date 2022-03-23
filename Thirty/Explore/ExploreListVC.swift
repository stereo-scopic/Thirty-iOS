//
//  ExploreListVC.swift
//  Thirty
//
//  Created by hakyung on 2022/03/17.
//

import UIKit

class ExploreListVC: UIViewController {

    @IBAction func backButtonTouchUpInside(_ sender: Any) {
//        self.navigationController?.popViewController(animated: false)
        self.popVC(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ExploreListVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreListCell", for: indexPath) as? ExploreListCell else { return UICollectionViewCell() }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let exploreDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ExploreDetailVC") as! ExploreDetailVC
        self.navigationController?.pushViewController(exploreDetailVC, animated: false)
        
    }
    
    
}

class ExploreListCell: UICollectionViewCell{
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonTouchUpInside(_ sender: Any){
        
    }
}
