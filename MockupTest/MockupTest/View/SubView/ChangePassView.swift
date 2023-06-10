//
//  ChangePassView.swift
//  MockupTest
//
//  Created by Kit Foong on 09/06/2023.
//

import UIKit
import Toast
import SkyFloatingLabelTextField
import CHIOTPField
import Lottie

protocol ChangePassViewDelegate {
    func completeChangePass(status: Bool)
}

class ChangePassView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var enterDetailView: UIView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailBorderView: UIView!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLottie: LottieAnimationView!
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultSubtitleLabel: UILabel!
    
    
    var currentUser: CurrentUser!
    var confirmPassword: String = ""
    var isEmail: Bool = true
    var delegate: ChangePassViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    private func setupUI() {
        Bundle.main.loadNibNamed(String(describing: ChangePassView.self), owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.isUserInteractionEnabled = true
        
        addSubview(contentView)
        
        emailBorderView.layer.borderWidth = 1
        emailBorderView.layer.borderColor = UIColor(red: 31/255, green: 84/255, blue: 96/255, alpha: 0.4).cgColor
        emailBorderView.roundCorner(5)
        emailTextField.titleFont = UIFont.systemFont(ofSize: 10)
        emailTextField.keyboardType = .emailAddress
        
        sendButton.roundCorner(10)
        sendButton.backgroundColor = UIColor(red: 44/255, green: 183/255, blue: 134/255, alpha: 1.0)
        sendButton.tintColor = .white
        
        emailTextField.becomeFirstResponder()
        
        emailTextField.text = "kitfoong94@gmail.com"
    }
    
    @IBAction func sendAction(_ sender: Any) {
        if isEmail {
            if emailTextField.text.orEmpty.isEmpty {
                makeToast("Please fill up all the fields", duration: 2, position: CSToastPositionCenter)
                return
            }
            
            if currentUser.email != emailTextField.text {
                makeToast("User does not exist", duration: 2, position: CSToastPositionCenter)
                return
            }
            
            endEditing(true)
            isEmail = false
            subtitleLabel.text = "Enter the 4 digits code that you received on your email."
            emailView.makeHidden()
            otpView.makeVisible()
            otpTextField.becomeFirstResponder()
        } else {
            if otpTextField.text.orEmpty.isEmpty {
                makeToast("Please fill up all the fields", duration: 2, position: CSToastPositionCenter)
                return
            }
            
            endEditing(true)
            
            CurrentUserController().changePassword(user: currentUser, password: confirmPassword, complete: { (status, message) in
                self.makeToast(message, duration: 2, position: CSToastPositionCenter)

                self.enterDetailView.makeHidden()
                self.resultView.makeVisible()

                self.resultLottie.loopMode = .loop

                if status {
                    self.resultLottie.animation = LottieAnimation .named("success")
                    self.resultTitleLabel.text = "Successfully Change Password"
                } else {
                    self.resultLottie.animation = LottieAnimation.named("error")
                    self.resultTitleLabel.text = "Unsuccessfully Change Password"
                }

                self.resultLottie.play()

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.delegate?.completeChangePass(status: status)
                }
            })
        }
    }
}
