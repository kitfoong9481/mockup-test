//
//  UIView+Extension.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import Foundation
import UIKit

public extension UIView {
    func makeHidden() {
        self.isHidden = true
    }
    
    func makeVisible() {
        self.isHidden = false
    }
    
    func roundCorner(_ radius: CGFloat = 5.0) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
}
