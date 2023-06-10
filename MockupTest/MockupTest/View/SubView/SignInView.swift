//
//  SignInView.swift
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
import CoreData

protocol SignInViewDelegate {
    func loginTapped()
    func successLogin()
}

class SignInView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordBorderView: UIView!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var signUpLabel: UILabel!
    
    var currentUser: CurrentUser!
    var signInDelegate: SignInViewDelegate?
    var passwordEntry = true
    
    init() {
        super.init(frame: .zero)
        getCurrentUser()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        getCurrentUser()
        setupUI()
    }
    
    func getCurrentUser() {
        CurrentUserController().fetchUser(complete: { (user, status, message) in
            if status {
                self.currentUser = user!
            } else {
                self.makeToast(message, duration: 2, position: CSToastPositionCenter)
            }
        })
    }
    
    private func setupUI() {
        Bundle.main.loadNibNamed(String(describing: SignInView.self), owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.isUserInteractionEnabled = true
        
        addSubview(contentView)
        
        emailBorderView.layer.borderWidth = 1
        emailBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        emailBorderView.roundCorner(5)
        emailTextField.titleFont = UIFont.systemFont(ofSize: 10)
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        
        passwordBorderView.layer.borderWidth = 1
        passwordBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        passwordBorderView.roundCorner(5)
        passwordTextField.titleFont = UIFont.systemFont(ofSize: 10)
        passwordTextField.isSecureTextEntry = passwordEntry
        passwordTextField.delegate = self
        
        signInButton.roundCorner(10)
        signInButton.backgroundColor = UIColor(red: 44/255, green: 183/255, blue: 134/255, alpha: 1.0)
        signInButton.tintColor = .white
        
        googleView.roundCorner(10)
        googleView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        appleView.roundCorner(10)
        appleView.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 2.0, opacity: 0.35)
        
        let text = "Dont't have account? Sign up"
        signUpLabel.text = text
        signUpLabel.font = UIFont(name: "Sora", size: 14)
        signUpLabel.textColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 1.0)
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Sign up")
        
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineColor, value:  UIColor(red: 41/255, green: 183/255, blue: 134/255, alpha: 1.0), range: range)
        signUpLabel.attributedText = underlineAttriString
        signUpLabel.isUserInteractionEnabled = true
        signUpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnLabel(_:))))
        
//        emailTextField.text = "kitfoong94@gmail.com"
//        passwordTextField.text = "123qwe"
    }
    
    @objc func handleTapOnLabel(_ recognizer: UITapGestureRecognizer) {
        guard let text = signUpLabel.attributedText?.string else {
            return
        }
        
        if let range = text.range(of: "Sign up"),
           recognizer.didTapAttributedTextInLabel(label: signUpLabel, inRange: NSRange(range, in: text)) {
            signInDelegate?.loginTapped()
        }
    }
    
    @IBAction func signInAction(_ sender: Any) {
        if emailTextField.text.orEmpty.isEmpty || passwordTextField.text.orEmpty.isEmpty  {
            makeToast("Please fill up all the fields", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        if emailTextField.text != currentUser.email || passwordTextField.text != currentUser.password {
            makeToast("Invalid Credential", duration: 2, position: CSToastPositionCenter)
            return
        }
        
        verifyCurrentUser(user: User(userId: "", username: "", email: emailTextField.text.orEmpty, password: passwordTextField.text.orEmpty, loginType: 1))
    }
    
    @IBAction func googleAction(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        guard let viewController = UIApplication.shared.currentUIWindow()?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.configuration = config
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
                
                self.verifyCurrentUser(user: User(userId: idToken.tokenString, username: user.profile?.name ?? "", email: user.profile?.email ?? "", password: "", loginType: 2))
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
    
    @IBAction func showPassAction(_ sender: Any) {
        passwordEntry = !passwordEntry
        passwordTextField.isSecureTextEntry = passwordEntry
    }
    
    func verifyCurrentUser(user: User) {
        CurrentUserController().signInUser(user: user, complete: { (status, message) in
            self.makeToast(message, duration: 2, position: CSToastPositionCenter)
            
            if status {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.signInDelegate?.successLogin()
                }
            }
        })
    }
}

extension SignInView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignInView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userID = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
              
            verifyCurrentUser(user: User(userId: userID, username: fullName?.givenName.orEmpty ?? "", email: email ?? "", password: "", loginType: 3))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        makeToast(error.localizedDescription, duration: 2, position: CSToastPositionCenter)
    }
}
