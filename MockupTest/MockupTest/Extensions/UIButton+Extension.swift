//
//  UIButton+Extension.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import UIKit

extension UIButton {
    func set(title: String?, titleColor: UIColor, image: UIImage? = nil, bgImage: UIImage? = nil, for state: UIControl.State) -> Void {
        self.setTitle(title, for: state)
        self.setTitleColor(titleColor, for: state)
        self.setImage(image, for: state)
        self.setBackgroundImage(bgImage, for: state)
    }

    func set(font: UIFont?, cornerRadius: CGFloat = 0, borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear) -> Void {
        if let font = font {
            self.titleLabel?.font = font
        }
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        // 图片拉伸样式设置
        self.contentMode = .scaleAspectFill
    }
}
