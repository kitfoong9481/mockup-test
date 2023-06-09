//
//  DashboardSelectionCell.swift
//  MockupTest
//
//  Created by Kit Foong on 08/06/2023.
//

import UIKit

class DashboardSelectionCell: UICollectionViewCell {
    @IBOutlet weak var selectionButton: UIButton!
    
    static let cellIdentifier = "DashboardSelectionCell"
    
    class func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionButton.roundCorner(18)
        selectionButton.backgroundColor = UIColor(red: 0.837, green: 0.872, blue: 0.879, alpha: 1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    func configure(selection: DashboardSelection) {
        selectionButton.titleLabel?.text = selection.title
        if selection.isSelected {
            selectionButton.backgroundColor = UIColor(red: 0, green: 0.263, blue: 0.318, alpha: 1)
            selectionButton.titleLabel?.textColor = .white
        } else {
            selectionButton.backgroundColor = UIColor(red: 0.837, green: 0.872, blue: 0.879, alpha: 1)
            selectionButton.titleLabel?.textColor = .black
            
        }
        
        selectionButton.titleLabel?.sizeToFit()
    }
}
