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
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bucketAnswerDateLabel: UILabel!
    @IBOutlet weak var bucketAnswerTitleLabel: UILabel!
    @IBOutlet weak var bucketAnswerTextView: UITextView!
    
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var linkImageView: UIImageView!
    
    @IBOutlet weak var bucketImgView: UIView!
    @IBOutlet weak var bucketImageDeleteButton: UIButton!
    @IBOutlet weak var bucketImageView: UIImageView!
    
    @IBOutlet weak var badgeView: UIView!
    @IBOutlet weak var badgeImageView: UIImageView!
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var bucketId: String = ""
    var bucketAnswer: BucketAnswer = BucketAnswer(stamp: 0)
    var selectedStamp: Int = 0
    var editFlag = false
    var textViewPlaceHolder = "내용을 입력하세요."
    
    typealias Reactor = BucketAnswerEnrollReactor
    var disposeBag = DisposeBag()
    var bucketCompleteFlag = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bucketAnswerTextView.delegate = self
        let scrollTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
        scrollView.addGestureRecognizer(scrollTapGesture)
        
        self.reactor = BucketAnswerEnrollReactor(bucketAnswer)
    }
    
    @objc func tapScrollView() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let stampPopupVC = segue.destination as? BucketStampPopupVC {
            stampPopupVC.selectedStamp
                .subscribe(onNext: { stampNum in
                    if stampNum != 0 {
                        self.badgeView.isHidden = false
                        self.badgeImageView.image = UIImage(named: "badge_\(stampNum)")
                        self.selectedStamp = stampNum
                    }
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
                var bucketAnswerText = ""
                if self.bucketAnswerTextView.text != self.textViewPlaceHolder {
                    bucketAnswerText = self.bucketAnswerTextView.text
                }
                
                if bucketAnswerText.isEmpty && self.selectedStamp == 0 && self.bucketImgView.isHidden {
                    self.view.showToast(message: "내용 또는 스탬프를 입력해주세요.")
                    return
                }
                
                self.loadingView.isHidden = false
                self.loadingIndicator.startAnimating()
                let bucketAnswer = BucketAnswer(answerid: self.bucketAnswer.answerid,
                                                music: "",
                                                date: self.bucketAnswer.date,
                                                detail: bucketAnswerText,
                                                image: "",
                                                stamp: self.selectedStamp)
                
                if self.editFlag {
                    if !self.bucketImgView.isHidden {
                        reactor.action.onNext(.editAnswer(self.bucketId, self.bucketAnswer.date, bucketAnswer, self.bucketImageView.image))
                    } else {
                        reactor.action.onNext(.editAnswer(self.bucketId, self.bucketAnswer.date, bucketAnswer, nil))
                    }
                } else {
                    if !self.bucketImgView.isHidden {
                        reactor.action.onNext(.enrollAnswer(self.bucketId, bucketAnswer, self.bucketImageView.image))
                    } else {
                        reactor.action.onNext(.enrollAnswer(self.bucketId, bucketAnswer, nil))
                    }
                }
            }.disposed(by: disposeBag)
        
        galleryButton.rx.tap
            .bind {
                let vc = UIImagePickerController()
                vc.sourceType = .photoLibrary
                vc.delegate = self
                vc.allowsEditing = true
                self.present(vc, animated: true)
            }.disposed(by: disposeBag)
        
        bucketImageDeleteButton.rx.tap
            .bind {
                self.bucketImgView.isHidden = true
                self.bucketImageView.image = UIImage()
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
                    self.loadingIndicator.stopAnimating()
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
                    self.loadingIndicator.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
        
        if editFlag, !bucketAnswerTextView.text.isEmpty {
            bucketAnswerTextView.textColor = .black
        }
    }
}

extension BucketAnswerEnrollVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .gray300
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= 700 else { return false }

        return true
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
