//
//  SignUpViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import Foundation
import UIKit
import FINNBottomSheet

class SignUpViewController: TSViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var signUpView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        signUpView.signUpDelegate = self
        
        setCloseButton()
        
        titleLabel.textColor = UIColor(red: 0/255, green: 67/255, blue: 81/255, alpha: 1.0)
        subTitleLabel.textColor = UIColor(red: 0.529, green: 0.621, blue: 0.642, alpha: 1)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(tap:)))
        view.addGestureRecognizer(tap)
        
        let screenHeight = UIScreen.main.bounds.height
        
        let bottomSheetView = BottomSheetView(
            contentView: signUpView,
            contentHeights: [screenHeight * 0.7]
        )
        
        bottomSheetView.present(in: self.view, targetIndex: 0)
    }
    
    @objc func dismissKeyboard(tap: UIGestureRecognizer) {
        view.endEditing(true)
    }
}

extension SignUpViewController: SignUpViewDelegate {
    func loginTapped() {
        let vc : SignInViewController = self.storyboard?.instantiateViewController(withIdentifier: "signIn") as! SignInViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func successSignUp() {
        let vc : DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

