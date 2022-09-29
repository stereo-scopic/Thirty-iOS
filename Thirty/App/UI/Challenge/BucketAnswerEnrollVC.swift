//
//  BucketAnswerEnrollVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/27.
//

import UIKit
import ReactorKit

class BucketAnswerEnrollVC: UIViewController, StoryboardView {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var bucketAnswerDateLabel: UILabel!
    @IBOutlet weak var bucketAnswerTitleLabel: UILabel!
    @IBOutlet weak var bucketAnswerTextView: UITextView!
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkImageView: UIImageView!
    
    @IBOutlet weak var bucketImgView: UIView!
    @IBOutlet weak var bucketImageView: UIImageView!
    
    @IBOutlet weak var galleryButton: UIButton!
    
    var bucketId: String = ""
    var bucketAnswer: BucketAnswer = BucketAnswer(stamp: 0)
    
    typealias Reactor = BucketAnswerEnrollReactor
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = BucketAnswerEnrollReactor(bucketAnswer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func bind(reactor: BucketAnswerEnrollReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: BucketAnswerEnrollReactor) {
        backButton.rx.tap
            .bind {
                self.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind {
                let bucketAnswer = BucketAnswer(id: self.bucketAnswer.id,
                                                music: "",
                                                date: self.bucketAnswer.date,
                                                detail: self.bucketAnswerTextView.text,
                                                image: "",
                                                stamp: 1)
                
                reactor.action.onNext(.enrollAnswer(self.bucketId, bucketAnswer))
            }.disposed(by: disposeBag)
        
        galleryButton.rx.tap
            .bind {
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: BucketAnswerEnrollReactor) {
        reactor.state
            .map { $0.bucketAnswer }
            .subscribe(onNext: { [weak self] bucketAnswer in
                self?.bucketAnswerDateLabel.text = "#\(bucketAnswer.date)"
                self?.bucketAnswerTitleLabel.text = bucketAnswer.mission
                
                if let bucketImage = bucketAnswer.image {
                    self?.bucketImgView.isHidden = false
                    if let imageUrl = URL(string: bucketImage) {
                        self?.bucketImageView.load(url: imageUrl)
                    }
                } else {
                    self?.bucketImgView.isHidden = true
                }
                
//                if let linkImage = bucketAnswer.
                
            }).disposed(by: disposeBag)
    }

}

extension BucketAnswerEnrollVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            bucketImageView.isHidden = false
            bucketImageView.image = image
        }
                
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
