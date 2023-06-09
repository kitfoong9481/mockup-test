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
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    func circleCorner() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func roundCornerWithCorner(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
