//
//  BucketAnswerEnrollVC.swift
//  Thirty
//
//  Created by hakyung on 2022/09/27.
//

import UIKit
import ReactorKit
import RxRelay

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
    
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBOutlet weak var galleryButton: UIButton!
    
    var bucketId: String = ""
    var bucketAnswer: BucketAnswer = BucketAnswer(stamp: 0)
    var selectedStamp: Int = 0
    var editFlag = false
    
    typealias Reactor = BucketAnswerEnrollReactor
    var disposeBag = DisposeBag()
    var bucketCompleteFlag = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = BucketAnswerEnrollReactor(bucketAnswer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stampPopupVC = segue.destination as? BucketStampPopupVC {
            stampPopupVC.selectedStamp
                .subscribe(onNext: { stampNum in
                    self.badgeView.isHidden = false
                    self.badgeImageView.image = UIImage(named: "badge_\(stampNum)")
                    self.selectedStamp = stampNum
                }).disposed(by: disposeBag)
        }
    }
    
    func bind(reactor: BucketAnswerEnrollReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: BucketAnswerEnrollReactor) {
        backButton.rx.tap
            .bind {
                let alert = UIAlertController(title: "", message: "작성 중인 내용은 사라집니다.\n나가시겠습니까?", preferredStyle: .alert)
                let backAction = UIAlertAction(title: "나가기", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                let cancelAction = UIAlertAction(title: "계속 작성하기", style: .default) { _ in
                    
                }
                alert.addAction(cancelAction)
                alert.addAction(backAction)
                
                self.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind {
                let bucketAnswer = BucketAnswer(answerid: self.bucketAnswer.answerid,
                                                music: "",
                                                date: self.bucketAnswer.date,
                                                detail: self.bucketAnswerTextView.text,
                                                image: "",
                                                stamp: self.selectedStamp)
                
                if self.editFlag {
                    reactor.action.onNext(.editAnswer(self.bucketId, self.bucketAnswer.date, bucketAnswer))
                } else {
                    if !self.bucketImgView.isHidden {
                        reactor.action.onNext(.enrollAnswer(self.bucketId, bucketAnswer, self.bucketImageView.image))
                    } else {
                        reactor.action.onNext(.enrollAnswer(self.bucketId, bucketAnswer, nil))
                    }
                }
//                self.navigationController?.popViewController(animated: true)
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
                if let edit = self?.editFlag, edit {
                    
                    if let bucketImage = bucketAnswer.image, !bucketImage.isEmpty {
                        self?.bucketImgView.isHidden = false
                        if let imageUrl = URL(string: bucketImage) {
                            self?.bucketImageView.load(url: imageUrl)
                        }
                    } else {
                        self?.bucketImgView.isHidden = true
                    }
                    
                    if let stampNum = bucketAnswer.stamp, stampNum != 0 {
                        self?.badgeView.isHidden = false
                        self?.badgeImageView.image = UIImage(named: "badge_\(stampNum)")
                        self?.selectedStamp = stampNum
                    } else {
                        self?.badgeView.isHidden = true
                    }
                    
                    self?.bucketAnswerTextView.text = bucketAnswer.detail
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.enrollStatus }
            .subscribe(onNext: { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bucketStatus }
            .subscribe(onNext: { status in
                if status == .CMP {
                    self.bucketCompleteFlag.accept(true)
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bucketCompleted }
            .subscribe(onNext: { completeFlag in
                if completeFlag {
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
    }

}

extension BucketAnswerEnrollVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            bucketImgView.isHidden = false
            bucketImageView.image = image
        }
                
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
}
