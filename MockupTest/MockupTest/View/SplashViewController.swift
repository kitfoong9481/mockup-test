//
//  ViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import UIKit
import Lottie

class SplashViewController: TSViewController {
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieView.loopMode = .loop
        lottieView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            CurrentUserController().checkUserIsLogin(complete: { (isLogin) in
                if isLogin {
                    let vc : DashboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "dashboard") as! DashboardViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc : OnboardViewController = self.storyboard?.instantiateViewController(withIdentifier: "onboard") as! OnboardViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            })
        }
    }
}

