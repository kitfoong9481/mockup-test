//
//  AddAccountViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 10/06/2023.
//

import Foundation
import UIKit
import Toast
import SkyFloatingLabelTextField

class AddAccountViewController: TSViewController {
    @IBOutlet weak var loginBorderView: UIView!
    @IBOutlet weak var loginTypeTextField: UITextField!
    @IBOutlet weak var webBorderView: UIView!
    @IBOutlet weak var webNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var urlBorderView: UIView!
    @IBOutlet weak var urlTextfield: SkyFloatingLabelTextField!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var pickerView = UIPickerView()
    
    var passwordEntry = true
    var loginTypes: [String] = ["Login", "Card", "Others"]
    
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
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.917, alpha: 1)
        
        setCloseButton()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(tap:)))
        view.addGestureRecognizer(tap)
        
        loginBorderView.layer.borderWidth = 1
        loginBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        loginBorderView.roundCorner(5)
        loginTypeTextField.inputView = pickerView
        loginTypeTextField.text = loginTypes.first
        
        webBorderView.layer.borderWidth = 1
        webBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        webBorderView.roundCorner(5)
        webNameTextField.delegate = self
        
        urlBorderView.layer.borderWidth = 1
        urlBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        urlBorderView.roundCorner(5)
        urlTextfield.keyboardType = .URL
        urlTextfield.delegate = self
        
        usernameView.layer.borderWidth = 1
        usernameView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        usernameView.roundCorner(5)
        usernameTextField.delegate = self
        
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        emailView.roundCorner(5)
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        passwordView.roundCorner(5)
        passwordTextField.isSecureTextEntry = passwordEntry
        passwordTextField.delegate = self
        
        saveButton.roundCorner(10)
        saveButton.backgroundColor = UIColor(red: 44/255, green: 183/255, blue: 134/255, alpha: 1.0)
        saveButton.tintColor = .white
        
        cancelButton.tintColor = UIColor(red: 0/255, green: 67/255, blue: 81/255, alpha: 1.0)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelToolButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))
    
        toolbar.setItems([cancelToolButton, spaceButton, doneButton], animated: false)
        
        // add toolbar to textField
        loginTypeTextField.inputAccessoryView = toolbar
        
        webNameTextField.text = "Instagram"
        urlTextfield.text = "www.instagram.com"
        usernameTextField.text = "loki"
        emailTextField.text = "loki@gmail.com"
        passwordTextField.text = "123455"
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
        let selectedTitle = loginTypes[pickerView.selectedRow(inComponent: 0)]
        self.loginTypeTextField.text = selectedTitle
    }

    @objc func cancelTapped() {
        view.endEditing(true)
    }
    
    @objc func dismissKeyboard(tap: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func showPassAction(_ sender: Any) {
        passwordEntry = !passwordEntry
        passwordTextField.isSecureTextEntry = passwordEntry
    }
    
    @IBAction func copyAction(_ sender: Any) {
        if passwordTextField.text.orEmpty.isEmpty == false {
            UIPasteboard.general.string = passwordTextField.text
            self.view.makeToast("Copied", duration: 2, position: CSToastPositionCenter)
        } else {
            self.view.makeToast("Please fill up password first", duration: 2, position: CSToastPositionCenter)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if loginTypeTextField.text.orEmpty.isEmpty || webNameTextField.text.orEmpty.isEmpty || urlTextfield.text.orEmpty.isEmpty || usernameTextField.text.orEmpty.isEmpty || emailTextField.text.orEmpty.isEmpty || passwordTextField.text.orEmpty.isEmpty {
            self.view.makeToast("Please fill up all the fields", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        var accountType: Int32 = 1
        
        if loginTypeTextField.text == "Login" {
            accountType = 1
        } else if loginTypeTextField.text == "Card" {
            accountType = 2
        } else if loginTypeTextField.text == "Others" {
            accountType = 3
        }
        
        AccountController().checkExistUser(email: emailTextField.text.orEmpty, complete: { (status, message) in
            if status == false {
                self.view.makeToast(message, duration: 2, position: CSToastPositionCenter)
                return
            }
            
            AccountController().createNewAccount(account: NewAccount(accountType: accountType, webName: self.webNameTextField.text.orEmpty, url: self.urlTextfield.text.orEmpty, username: self.usernameTextField.text.orEmpty, email: self.emailTextField.text.orEmpty, password: self.passwordTextField.text.orEmpty), complete: { (status, message) in
                self.view.makeToast(message, duration: 2, position: CSToastPositionCenter)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        })
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == webNameTextField {
            textField.resignFirstResponder()
            urlTextfield.becomeFirstResponder()
        } else if textField == urlTextfield {
            textField.resignFirstResponder()
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension AddAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loginTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return loginTypes[row]
    }
}
