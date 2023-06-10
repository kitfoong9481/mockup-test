//
//  DashboardTabController.swift
//  MockupTest
//
//  Created by Kit Foong on 09/06/2023.
//

import Foundation
import UIKit

class DashboardTabController: UITabBarController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
