//
//  CommunityListCell.swift
//  Thirty
//
//  Created by 송하경 on 2022/07/24.
//

import UIKit

class CommunityListCell: UITableViewCell {
    @IBOutlet weak var nicknameButton: UIButton!
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var challengeOrderLabel: UILabel!
    @IBOutlet weak var challengeNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var challengeCreatedAtLabel: UILabel!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var challengeImageStackView: UIStackView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    
    static var identifier = "CommunityListCell"
    
    var makeExpand: ((Bool) -> Void)?
    var addFriend: ((Bool) -> Void)?
    var nicknameClicked: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let labelClickEvent = UITapGestureRecognizer(target: self, action: #selector(self.labelClicked(sender:)))
        self.detailLabel.addGestureRecognizer(labelClickEvent)
    }
    
    @objc func labelClicked(sender: UITapGestureRecognizer) {
        makeExpand?(true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func expandCell() {
        makeExpand?(true)
    }
    
    @IBAction func addFriendButtonClicked(_ sender: Any) {
        addFriend?(true)
    }
    
    @IBAction func nicknameButtonClicked(_ sender: Any) {
        nicknameClicked?()
    }
}
