//
//  OnboardViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import UIKit

class OnboardViewController: TSViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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
}
