//
//  SignUpView.swift
//  MockupTest
//
//  Created by Kit Foong on 07/06/2023.
//

import UIKit
import Toast
import Firebase
import GoogleSignIn
import AuthenticationServices
import SkyFloatingLabelTextField

protocol SignUpViewDelegate {
    func loginTapped()
    func successLogin()
}

class SignUpView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var usernameBorderView: UIView!
    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordBorderView: UIView!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassBorderView: UIView!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var loginLabel: UILabel!
    
    var signUpDelegate: SignUpViewDelegate?
    var passwordEntry = true, confirmPasswordEntry = true
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        Bundle.main.loadNibNamed(String(describing: SignUpView.self), owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.isUserInteractionEnabled = true
        
        addSubview(contentView)
        
        usernameBorderView.layer.borderWidth = 1
        usernameBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        usernameTextField.titleFont = UIFont.systemFont(ofSize: 10)
        usernameTextField.delegate = self
        
        emailBorderView.layer.borderWidth = 1
        emailBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        emailTextField.titleFont = UIFont.systemFont(ofSize: 10)
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        
        passwordBorderView.layer.borderWidth = 1
        passwordBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        passwordTextField.titleFont = UIFont.systemFont(ofSize: 10)
        passwordTextField.isSecureTextEntry = passwordEntry
        passwordTextField.delegate = self
        
        confirmPassBorderView.layer.borderWidth = 1
        confirmPassBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        confirmPassTextField.titleFont = UIFont.systemFont(ofSize: 10)
        confirmPassTextField.isSecureTextEntry = confirmPasswordEntry
        confirmPassTextField.delegate = self
        
        signUpButton.roundCorner(10)
        signUpButton.backgroundColor = UIColor(red: 44/255, green: 183/255, blue: 134/255, alpha: 1.0)
        signUpButton.tintColor = .white
        
        googleView.roundCorner(10)
        googleView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        appleView.roundCorner(10)
        appleView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        let text = "Already member? Log in"
        loginLabel.text = text
        loginLabel.font = UIFont(name: "Sora", size: 14)
        loginLabel.textColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 1.0)
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Log in")
        
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineColor, value:  UIColor(red: 41/255, green: 183/255, blue: 134/255, alpha: 1.0), range: range)
        loginLabel.attributedText = underlineAttriString
        loginLabel.isUserInteractionEnabled = true
        loginLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
    }
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = loginLabel.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "Log in"),
           recognizer.didTapAttributedTextInLabel(label: loginLabel, inRange: NSRange(range, in: text)) {
            signUpDelegate?.loginTapped()
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if usernameTextField.text.orEmpty.isEmpty || emailTextField.text.orEmpty.isEmpty || passwordTextField.text.orEmpty.isEmpty || confirmPassTextField.text.orEmpty.isEmpty {
            makeToast("Please fill up all the fields", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        if emailTextField.text?.isValidURL() == false {
            makeToast("Please enter a valid email", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        if passwordTextField.text != confirmPassTextField.text {
            makeToast("Password not match", duration: 2, position: CSToastPositionCenter)
            return
        }
    }
    
    @IBAction func googleAction(_ sender: Any) {
        guard let viewController = UIApplication.shared.currentUIWindow()?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { user, error in
            if let error = error {
                self.makeToast(error.localizedDescription, duration: 2, position: CSToastPositionCenter)
                return
            }
            
            guard let user = user?.user, let idToken = user.idToken else {
                self.makeToast("Error getting token", duration: 2, position: CSToastPositionCenter)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.makeToast(error.localizedDescription, duration: 2, position: CSToastPositionCenter)
                    return
                }
                
                self.makeToast("Success login", duration: 2, position: CSToastPositionCenter)
                self.signUpDelegate?.successLogin()
            }
        }
    }
    
    @IBAction func appleAction(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    @IBAction func showPasswordAction(_ sender: Any) {
        passwordEntry = !passwordEntry
        passwordTextField.isSecureTextEntry = passwordEntry
    }
    
    @IBAction func showConfirmPassAction(_ sender: Any) {
        confirmPasswordEntry = !confirmPasswordEntry
        confirmPassTextField.isSecureTextEntry = confirmPasswordEntry
    }
}

extension SignUpView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            confirmPassTextField.becomeFirstResponder()
        } else if textField == confirmPassTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignUpView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) {  (credentialState, error) in
                switch credentialState {
                case .authorized:
                    DispatchQueue.main.async {
                        self.makeToast("User already registered. Please proceed to Sign In", duration: 2, position: CSToastPositionCenter)
                    }
                    break
                case .notFound:
                    let fullName = appleIDCredential.fullName
                    let email = appleIDCredential.email
                    
                    DispatchQueue.main.async {
                        self.makeToast("User id is \(userID) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))", duration: 2, position: CSToastPositionCenter)
                        self.signUpDelegate?.successLogin()
                    }
                    break
                case .revoked:
                    DispatchQueue.main.async {
                        self.makeToast("The Apple ID credential is revoked", duration: 2, position: CSToastPositionCenter)
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        makeToast(error.localizedDescription, duration: 2, position: CSToastPositionCenter)
    }
}
