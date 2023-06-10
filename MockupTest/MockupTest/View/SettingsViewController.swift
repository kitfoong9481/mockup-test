//
//  SettingsViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 09/06/2023.
//

import Foundation
import UIKit
import Toast

class SettingsViewController: TSViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var updatedAtlabel: UILabel!
    @IBOutlet weak var inviteFriendsLabel: UILabel!
    @IBOutlet weak var changePassStackView: UIStackView!
    
    var currentUser: CurrentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        setupView()
    }
    
    func getCurrentUser() {
        CurrentUserController().fetchUser(complete: { (user, status, message) in
            if status {
                self.currentUser = user!
            } else {
                self.view.makeToast(message, duration: 2, position: CSToastPositionCenter)
            }
        })
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.917, alpha: 1)
        
        if currentUser.loginType == 3 {
            usernameLabel.text = currentUser.userId ?? ""
        } else {
            usernameLabel.text = currentUser.username ?? ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        updatedAtlabel.text = formatter.string(from: currentUser.updateTime ?? Date())
        
        if currentUser.loginType == 1 {
            changePassStackView.makeVisible()
        } else {
            changePassStackView.makeHidden()
        }
    }
    
    @IBAction func changePassAction(_ sender: Any) {
        let vc : ChangePassViewController = self.storyboard?.instantiateViewController(withIdentifier: "changePass") as! ChangePassViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        CurrentUserController().logout(user: currentUser, complete: { (status, message) in
            if status == false {
                self.view.makeToast(message, duration: 2, position: CSToastPositionCenter)
            }
            
            let vc : OnboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "onboard") as! OnboardViewController
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
}
