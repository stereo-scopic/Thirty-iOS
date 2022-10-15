//
//  ChallengeExportVC.swift
//  Thirty
//
//  Created by hakyung on 2022/06/23.
//

import UIKit
import ReactorKit
import RxRelay
import RxGesture
import Kingfisher

class ChallengeExportVC: UIViewController, StoryboardView {
    typealias Reactor = ChallengeExportReactor
    var disposeBag = DisposeBag()
    var bucketId = ""
    var selectedTheme = BehaviorRelay<ExportTheme>(value: .simple)
    
    var themeColors: [UIColor] = []
    var themeImages: [UIImage] = []
    var selectedColorIndex = BehaviorRelay<Int>(value: 0)
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frameImageView: UIImageView!
    
    @IBOutlet weak var simpleThemeView: UIStackView!
    @IBOutlet weak var kitchThemeView: UIStackView!
    @IBOutlet weak var softThemeView: UIStackView!
    @IBOutlet weak var meyouThemeView: UIStackView!
    
    @IBOutlet weak var colorButton1: UIButton!
    @IBOutlet weak var colorButton2: UIButton!
    @IBOutlet weak var colorButton3: UIButton!
    @IBOutlet weak var colorButton1Up: UIButton!
    @IBOutlet weak var colorButton2Up: UIButton!
    @IBOutlet weak var colorButton3Up: UIButton!
    
    @IBOutlet weak var challengeExportcollectionView: UICollectionView!
    @IBAction func backButtonTouchUpInside(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = ChallengeExportReactor()
        reactor?.action.onNext(.viewWillAppear(bucketId))
        self.challengeExportcollectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ChallengeShareVC {
            dest.challengeImage = self.frameView.asImage()
        }
    }
    
    func bind(reactor: ChallengeExportReactor) {
        bindState(reactor)
        bindAction(reactor)
    }
    
    private func bindState(_ reactor: ChallengeExportReactor) {
        self.selectedTheme
            .subscribe(onNext: { theme in
                if theme == .simple || theme == .soft {
                    self.colorButton3.isHidden = true
                    self.colorButton3Up.isHidden = true
                } else {
                    self.colorButton3.isHidden = false
                    self.colorButton3Up.isHidden = false
                    self.colorButton3Up.setImage(UIImage(named: "\(theme.rawValue)_color_3"), for: .normal)
                }
                self.colorButton1Up.setImage(UIImage(named: "\(theme.rawValue)_color_1"), for: .normal)
                self.colorButton2Up.setImage(UIImage(named: "\(theme.rawValue)_color_2"), for: .normal)
                
                
                self.themeColors = theme.colors
                self.themeImages = theme.images
                self.selectedColorIndex.accept(0)
            }).disposed(by: disposeBag)
        
        self.selectedColorIndex
            .subscribe(onNext: { index in
                self.frameImageView.image = self.themeImages[index]
                self.backgroundView.backgroundColor = self.themeColors[index]
            }).disposed(by: disposeBag)
        
        reactor.state
            .map { $0.bucketDetail?.answers ?? [] }
            .bind(to: challengeExportcollectionView.rx.items(cellIdentifier: ThirtyExportCell.identifier, cellType: ThirtyExportCell.self)) { index, item, cell in
                
                cell.number.text = "\(index + 1)"
                
                if (index / 6) % 2 == 0 {
                    cell.view.backgroundColor = index % 2 == 0 ? UIColor.gray50 : UIColor.thirtyBlack
                    cell.number.textColor = index % 2 == 0 ? UIColor.thirtyBlack : UIColor.white
                } else {
                    cell.view.backgroundColor = index % 2 == 0 ? UIColor.thirtyBlack : UIColor.gray50
                    cell.number.textColor = index % 2 == 0 ? UIColor.white : UIColor.thirtyBlack
                }
                
                if let bucketImage = item.image, !bucketImage.isEmpty {
                    if let imageUrl = URL(string: bucketImage) {
//                        cell.bucketAnswerImage.load(url: imageUrl)
                        cell.bucketAnswerImage.kf.setImage(with: imageUrl)
                        cell.number.isHidden = true
                    } else {
                        cell.bucketAnswerImage.image = UIImage()
                        cell.number.isHidden = false
                    }
                } else {
                    cell.bucketAnswerImage.image = UIImage()
                    cell.number.isHidden = false
                    
                    if let stamp = item.stamp, stamp != 0 {
                        cell.badgeImage.image = UIImage(named: "badge_trans_\(stamp)")
                        cell.number.isHidden = true
                    } else {
                        cell.badgeImage.image = UIImage()
                    }
                }
                
            }.disposed(by: disposeBag)
    }
    
    private func bindAction(_ reactor: ChallengeExportReactor) {
        simpleThemeView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.selectedTheme.accept(.simple)
            }.disposed(by: disposeBag)
        
        kitchThemeView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.selectedTheme.accept(.kitch)
            }.disposed(by: disposeBag)
        
        softThemeView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.selectedTheme.accept(.soft)
            }.disposed(by: disposeBag)
        
        meyouThemeView.rx.tapGesture()
            .when(.recognized)
            .bind { _ in
                self.selectedTheme.accept(.meyou)
            }.disposed(by: disposeBag)
        
        colorButton1Up.rx.tap
            .subscribe(onNext: {
                self.selectedColorIndex.accept(0)
            }).disposed(by: disposeBag)
        
        colorButton2Up.rx.tap
            .bind { _ in
                self.selectedColorIndex.accept(1)
            }.disposed(by: disposeBag)
        
        colorButton3Up.rx.tap
            .bind { _ in
                self.selectedColorIndex.accept(2)
            }.disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind {
                UIImageWriteToSavedPhotosAlbum(self.frameView.asImage(), self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }.disposed(by: disposeBag)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print(error)
        }else {
            print("success")
            //            guard let challengeShareVC = self.storyboard?
            //                    .instantiateViewController(withIdentifier: "ChallengeShareVC") as? ChallengeShareVC else { return }
            //            self.navigationController?.pushViewController(challengeShareVC, animated: false)
            //
            self.performSegue(withIdentifier: "goCompletePopup", sender: self)
        }
    }
}

extension ChallengeExportVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width) / 6
        let height: CGFloat = (collectionView.bounds.height) / 5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

enum ExportTheme: String {
    case simple
    case kitch
    case soft
    case meyou
    
    var colors: [UIColor] {
        switch self {
        case .simple:
            return [UIColor(hex: "FFFFFF"), UIColor(hex: "212121")]
        case .kitch:
            return [UIColor(hex: "FF5B40"), UIColor(hex: "212121"), UIColor(hex: "FFA1CE")]
        case .soft:
            return [UIColor(hex: "FEFFE3"), UIColor(hex: "FFE6F0")]
        case .meyou:
            return [UIColor(hex: "FFFFFF"), UIColor(hex: "19BF7A"), UIColor(hex: "FFC6CA")]
        }
    }
    
    var images: [UIImage] {
        switch self {
        case .simple:
            return [UIImage(named: "simple_1")!, UIImage(named: "simple_2")!]
        case .kitch:
            return [UIImage(named: "kitch_1")!, UIImage(named: "kitch_2")!, UIImage(named: "kitch_3")!]
        case .soft:
            return [UIImage(named: "soft_1")!, UIImage(named: "soft_2")!]
        case .meyou:
            return [UIImage(named: "meyou_1")!, UIImage(named: "meyou_2")!, UIImage(named: "meyou_3")!]
        }
    }
    
}

class ThirtyExportCell: UICollectionViewCell {
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var bucketAnswerImage: UIImageView!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    static var identifier = "ThirtyExportCell"
    
    override func awakeFromNib() {
    }
    
    override func prepareForReuse() {
        cellWidth.constant = (UIScreen.main.bounds.width - 53) / 6
        bucketAnswerImage.image = UIImage()
    }
}
