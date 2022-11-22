//
//  CreateChallengeVC.swift
//  Thirty
//
//  Created by hakyung on 2022/07/07.
//

import UIKit
import RxSwift
import ReactorKit
import RxRelay

class CreateChallengeVC: UIViewController, StoryboardView {
    var buttonEnabled = Observable.just(false)
    var disposeBag = DisposeBag()
    typealias Reactor = CreateChallengeReactor
    
    var challengeTitleEmpty: Observable<Bool> = Observable.just(true)
    var challengeDescriptionEmpty: Observable<Bool> = Observable.just(true)
    
    var selectedIndex: Int = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var challengeTitleTextField: UITextField!
    @IBOutlet weak var challengeDescriptionTextField: UITextField!
    
    @IBOutlet weak var challengeMissionDate: UILabel!
    @IBOutlet weak var challengeMissionTextField: UITextField!
    
    @IBOutlet weak var challengeCollectionView: UICollectionView!
    
    var missions: [Mission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = CreateChallengeReactor()
        
        let scrollTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
        scrollView.addGestureRecognizer(scrollTapGesture)
        
        self.challengeMissionTextField.delegate = self
    }
    
    @objc func tapScrollView() {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func bind(reactor: CreateChallengeReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindState(_ reactor: CreateChallengeReactor) {
        reactor.state
            .map { $0.inputMissions }
            .bind(to: challengeCollectionView.rx.items(cellIdentifier: CreateChallengeCell.identifier, cellType: CreateChallengeCell.self)) { _, item, cell in
                cell.number.text = "#\(item.date + 1)"
                
                if let detail = item.detail, !detail.isEmpty {
                    cell.view.isHidden = false
                    cell.number.isHidden = true
                    cell.missionDate.text = "#\(item.date + 1)"
                    cell.missionTitle.text = item.detail
                } else {
                    cell.view.isHidden = true
                    cell.number.isHidden = false
                }
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.inputMissions }
            .bind { inputMissions in
                self.missions = inputMissions
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { $0.enrollMessage }
            .bind { [weak self] message in
                if !message.isEmpty {
                    self?.view.showToast(message: message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self?.navigationController?.popViewController(animated: true)
                        self?.tabBarController?.selectedIndex = 0
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: CreateChallengeReactor) {
        buttonEnabled
            .subscribe(onNext: { enable in
                self.completeButton.setTitleColor(enable ? UIColor.gray300:  UIColor.thirtyBlack, for: .normal)
            })
            .disposed(by: disposeBag)
        
        challengeTitleEmpty = challengeTitleTextField.rx.text.orEmpty
            .map { $0.isEmpty }
        
        challengeDescriptionEmpty = challengeDescriptionTextField.rx.text.orEmpty
            .map { $0.isEmpty }
        
        Observable.zip(challengeCollectionView.rx.modelSelected(Mission.self), challengeCollectionView.rx.itemSelected)
            .bind { [weak self] (mission, indexPath) in
                self?.selectedIndex = indexPath.row
                
                self?.challengeMissionDate.text = "#\(indexPath.row + 1)"
                if let detail = mission.detail, !detail.isEmpty {
                    self?.challengeMissionTextField.text = mission.detail
                }
                                
            }.disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind { [weak self] _ in
                guard let title = self?.challengeTitleTextField.text, let desc = self?.challengeDescriptionTextField.text,
                      !title.isEmpty, !desc.isEmpty else {
                          self?.view.showToast(message: "챌린지 제목/설명을 입력해주세요.")
                          return
                      }
                
                guard let missions = self?.missions, missions.count != 30 else {
                    self?.view.showToast(message: "미션을 30개 모두 입력해주세요.")
                    return
                }
                
                self?.reactor?.action.onNext(.enrollChallenge(title, desc, missions))
            }.disposed(by: disposeBag)
    }
}

extension CreateChallengeVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == challengeMissionTextField {
            self.reactor?.action.onNext(.addMissions(self.selectedIndex, textField.text ?? ""))
            self.challengeMissionTextField.text = ""
        }
    }
}

class CreateChallengeCell: UICollectionViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var missionTitle: UILabel!
    @IBOutlet weak var missionDate: UILabel!
    
    static var identifier = "CreateChallengeCell"
    
    override class func awakeFromNib() {
        
    }
}
