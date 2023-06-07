//
//  DashboardViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 07/06/2023.
//

import Foundation
import UIKit

class DashboardViewController: TSViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = true
    }
}
