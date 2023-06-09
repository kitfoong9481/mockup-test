//
//  UIViewController+Extension.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import UIKit

extension UIViewController {
    // shadowColor  - 设置导航栏分割线的颜色，默认为灰色
    func setClearNavBar(tint: UIColor = .black, shadowColor: UIColor = .clear) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = tint
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .clear
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = shadowColor
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
