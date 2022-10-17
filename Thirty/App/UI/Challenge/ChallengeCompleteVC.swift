//
//  ChallengeCompleteVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit
import RxSwift

class ChallengeCompleteVC: UIViewController {
    var bucketId: String = ""
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var completeButton: UIButton!
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let exportVC = segue.destination as? ChallengeExportVC {
            exportVC.bucketId = bucketId
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        completeButton.rx.tap
            .bind {
//                guard let challengeExportVC = self.storyboard?
//                        .instantiateViewController(withIdentifier: "ChallengeExportVC") as? ChallengeExportVC else { return }
//                challengeExportVC.bucketId = self.bucketId
//                self.present(challengeExportVC, animated: true, completion: nil)
                self.performSegue(withIdentifier: "goExport", sender: self)
            }.disposed(by: disposeBag)
    }
}
