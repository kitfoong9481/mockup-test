//
//  OnboardViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import UIKit

class OnboardViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        signUpButton.roundCorner(10)
        signUpButton.backgroundColor = UIColor(red: 44/255, green: 183/255, blue: 134/255, alpha: 1.0)
        signUpButton.tintColor = .white
        
        signInButton.roundCorner(10)
        signInButton.backgroundColor = UIColor(red: 0/255, green: 67/255, blue: 81/255, alpha: 1.0)
        signInButton.tintColor = .white
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        
    }
}
