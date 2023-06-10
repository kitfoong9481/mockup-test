//
//  ChangePassViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 09/06/2023.
//

import Foundation
import UIKit
import Toast
import FINNBottomSheet
import SkyFloatingLabelTextField

class ChangePassViewController: TSViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPassView: UIView!
    @IBOutlet weak var currentPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassView: UIView!
    @IBOutlet weak var newPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassView: UIView!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var changePassButton: UIButton!
    
    var currentUser: CurrentUser!
    var changePassView = ChangePassView()
    var bottomSheetView: BottomSheetView!
    var currentPassEntry = true, passwordEntry = true, confirmPasswordEntry = true
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.removeObserver(self)
    }
    
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
        
        setCloseButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        titleLabel.text = "Change\nPassword"
        titleLabel.textColor = UIColor(red: 0/255, green: 67/255, blue: 81/255, alpha: 1.0)
                
        currentPassView.layer.borderWidth = 1
        currentPassView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        currentPassView.roundCorner(5)
        currentPassTextField.titleFont = UIFont.systemFont(ofSize: 10)
        currentPassTextField.isSecureTextEntry = passwordEntry
        currentPassTextField.delegate = self
        
        newPassView.layer.borderWidth = 1
        newPassView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        newPassView.roundCorner(5)
        newPassTextField.titleFont = UIFont.systemFont(ofSize: 10)
        newPassTextField.isSecureTextEntry = passwordEntry
        newPassTextField.delegate = self
        
        confirmPassView.layer.borderWidth = 1
        confirmPassView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        confirmPassView.roundCorner(5)
        confirmPassTextField.titleFont = UIFont.systemFont(ofSize: 10)
        confirmPassTextField.isSecureTextEntry = passwordEntry
        confirmPassTextField.delegate = self
        
        changePassButton.roundCorner(10)
        changePassButton.backgroundColor = UIColor(red: 44/255, green: 183/255, blue: 134/255, alpha: 1.0)
        changePassButton.tintColor = .white
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(tap:)))
        view.addGestureRecognizer(tap)
        
        changePassView.currentUser = currentUser
        changePassView.delegate = self
        
        bottomSheetView = BottomSheetView(
            contentView: changePassView,
            contentHeights: [screenHeight * 0.75])
        bottomSheetView.dismissalDelegate = self
        
        currentPassTextField.text = "123qwe"
        newPassTextField.text = "123qwe"
        confirmPassTextField.text = "123qwe"
    }
    
    @objc func dismissKeyboard(tap: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear() {
        bottomSheetView.reload(with: [screenHeight * 0.75], targetIndex: 0)
    }

    @objc func keyboardWillDisappear() {
        bottomSheetView.reload(with: [screenHeight * 0.4], targetIndex: 0)
    }
    
    @IBAction func currentPassAction(_ sender: Any) {
        currentPassEntry = !currentPassEntry
        currentPassTextField.isSecureTextEntry = currentPassEntry
    }
    
    @IBAction func newPassAction(_ sender: Any) {
        passwordEntry = !passwordEntry
        newPassTextField.isSecureTextEntry = passwordEntry
    }
    
    @IBAction func confirmPassAction(_ sender: Any) {
        confirmPasswordEntry = !confirmPasswordEntry
        confirmPassTextField.isSecureTextEntry = confirmPasswordEntry
    }
    
    @IBAction func changePassAction(_ sender: Any) {
        if currentPassTextField.text.orEmpty.isEmpty || newPassTextField.text.orEmpty.isEmpty || confirmPassTextField.text.orEmpty.isEmpty {
            view.makeToast("Please fill up all the fields", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        if currentPassTextField.text != currentUser.password {
            view.makeToast("Invalid old password", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        if newPassTextField.text != confirmPassTextField.text {
            view.makeToast("New password and Confirm password not match", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        changePassView.confirmPassword = confirmPassTextField.text ?? ""
        
        view.endEditing(true)
        currentPassTextField.isUserInteractionEnabled = false
        newPassTextField.isUserInteractionEnabled = false
        confirmPassTextField.isUserInteractionEnabled = false
        changePassButton.isUserInteractionEnabled = false
                
        bottomSheetView.present(in: self.view, targetIndex: 0)
    }
}

extension ChangePassViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPassTextField {
            textField.resignFirstResponder()
            newPassTextField.becomeFirstResponder()
        } else if textField == newPassTextField {
            textField.resignFirstResponder()
            confirmPassTextField.becomeFirstResponder()
        } else if textField == confirmPassTextField {
            textField.resignFirstResponder()
        } 
        return true
    }
}

extension ChangePassViewController: BottomSheetViewDismissalDelegate {
    func bottomSheetView(_ view: FINNBottomSheet.BottomSheetView, willDismissBy action: FINNBottomSheet.BottomSheetView.DismissAction) {
        bottomSheetView.dismiss()
        bottomSheetView = nil
        changePassView = ChangePassView()
        changePassView.currentUser = currentUser
        changePassView.confirmPassword = confirmPassTextField.text ?? ""
        changePassView.delegate = self
        bottomSheetView = BottomSheetView(
            contentView: changePassView,
            contentHeights: [screenHeight * 0.75])
        bottomSheetView.dismissalDelegate = self
        currentPassTextField.isUserInteractionEnabled = true
        newPassTextField.isUserInteractionEnabled = true
        confirmPassTextField.isUserInteractionEnabled = true
        changePassButton.isUserInteractionEnabled = true
    }
}

extension ChangePassViewController: ChangePassViewDelegate {
    func completeChangePass(status: Bool) {
        bottomSheetView.dismiss()
        
        if status {
            CurrentUserController().logout(user: currentUser, complete: { (status, message) in
                let vc : OnboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "onboard") as! OnboardViewController
                self.navigationController?.pushViewController(vc, animated: true)
            })
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
