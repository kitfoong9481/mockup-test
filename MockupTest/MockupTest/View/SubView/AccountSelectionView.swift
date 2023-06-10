//
//  AccountSelectionView.swift
//  MockupTest
//
//  Created by Kit Foong on 10/06/2023.
//

import UIKit
import Toast

class AccountSelectionView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var webNameLabel: UILabel!

    var currentIndex: Int = 0
    var account: Account!
    
    init(account: Account) {
        super.init(frame: .zero)
        self.account = account
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        Bundle.main.loadNibNamed(String(describing: AccountSelectionView.self), owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.isUserInteractionEnabled = true
        
        addSubview(contentView)
        
        contentView.roundCorner(15)
        webNameLabel.text = account.webName ?? ""
    }
    
    @IBAction func usernameCopyAction(_ sender: Any) {
        UIPasteboard.general.string = account.username
        makeToast("Username copied", duration: 2, position: CSToastPositionCenter)
    }
    
    @IBAction func passwordCopyAction(_ sender: Any) {
        UIPasteboard.general.string = account.password
        makeToast("Password copied", duration: 2, position: CSToastPositionCenter)
    }
}
