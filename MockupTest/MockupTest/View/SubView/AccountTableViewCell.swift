//
//  AccountTableViewCell.swift
//  MockupTest
//
//  Created by Kit Foong on 10/06/2023.
//

import UIKit

protocol AccountCellDelegate {
    func moreOnTap(for index: Int)
}

class AccountTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    static let cellIdentifier = "AccountTableViewCell"
    var currentIndex: Int = 0
    var delegate: AccountCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        contentView.roundCorner(10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
    }
    
    func configure(account: Account) {
        titleLabel.text = account.webName
        subTitleLabel.text = account.email
        contentView.roundCorner(10)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        self.delegate?.moreOnTap(for: currentIndex)
    }
}
