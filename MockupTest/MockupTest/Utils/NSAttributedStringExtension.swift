//
//  File.swift
//  MockupTest
//
//  Created by Kit Foong on 07/06/2023.
//

import UIKit

extension String {
    func attributonString() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
}

extension NSMutableAttributedString {
    func setlineSpacing(_ lineSpacing: CGFloat) -> NSMutableAttributedString {
        let attributeString = self
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = lineSpacing / 2.0
        paragraphStyle.headIndent = 0.000_1
        paragraphStyle.tailIndent = -0.000_1
        paragraphStyle.alignment = .left
        attributeString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributeString.length))
        return attributeString
    }
    
    
    func setUnderlinedAttributedText() -> NSMutableAttributedString {
        let attributeString = self
        let textRange = NSMakeRange(0, self.length)
        attributeString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        return attributeString
    }
}

