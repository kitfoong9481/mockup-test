//
//  TSViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 06/06/2023.
//

import UIKit

public class TSViewController: UIViewController {
    public override var shouldAutorotate: Bool { return false }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return [.portrait] }
    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit {
        print("deinit \(className)")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setTitleName(_ title: String = "") {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.textColor = .black
        label.font =  UIFont.systemFont(ofSize: 14.5, weight: .regular)
        label.backgroundColor = UIColor.clear
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = title
        self.navigationItem.titleView = label
    }
    
    func setCloseButton(backImage: Bool = false, titleStr: String? = nil, customView: UIView? = nil) {
        let image: UIImage
        if backImage == false {
            image = UIImage(named: "IMG_topbar_close")!
        } else {
            image = UIImage(named: "iconsArrowCaretleftBlack")!
        }
        let barButton = UIBarButtonItem(image: image, action: { [weak self] in
            let _ = self?.navigationController?.popViewController(animated: true)
        })
        barButton.tintColor = .black
        if let titleStr = titleStr {
            let btn = UIButton(type: .custom)
            btn.set(title: titleStr, titleColor: .black, for: .normal)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            let titleButton = UIBarButtonItem(customView: btn)
            self.navigationItem.leftBarButtonItems = [barButton, titleButton]
            return
        }
        if let customView = customView {
            let titleButton = UIBarButtonItem(customView: customView)
            self.navigationItem.leftBarButtonItems = [barButton, titleButton]
            return
        }
        self.navigationItem.leftBarButtonItem = barButton
    }
}
