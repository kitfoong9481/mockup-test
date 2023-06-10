//
//  DashboardViewController.swift
//  MockupTest
//
//  Created by Kit Foong on 07/06/2023.
//

import Foundation
import UIKit
import Toast
import Lottie

class DashboardViewController: TSViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var searhButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var secureView: UIView!
    @IBOutlet weak var secureLottieView: LottieAnimationView!
    @IBOutlet weak var secureLabel: UILabel!
    
    var selections: [DashboardSelection] = [DashboardSelection(title: "All Accounts", isSelected: true), DashboardSelection(title: "Login"), DashboardSelection(title: "Card"), DashboardSelection(title: "Others")]
    
    var currentUser: CurrentUser!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        setupView()
    }
    
    func getCurrentUser() {
        CurrentUserController().fetchUser(complete: { (user, status, message) in
            if status {
                self.currentUser = user!
            } else {
                self.view.makeToast(message, duration: 2, position: CSToastPositionCenter)
            }
        })
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 0.917, green: 0.917, blue: 0.917, alpha: 1)
        
        if currentUser.loginType == 3 {
            welcomeLabel.text = "Welcome\n\(currentUser.userId ?? "")!"
        } else {
            welcomeLabel.text = "Welcome\n\(currentUser.username ?? "")!"
        }

        welcomeLabel.textColor = UIColor(red: 0/255, green: 67/255, blue: 81/255, alpha: 1.0)
        
        searhButton.circleCorner()
        searhButton.backgroundColor = UIColor(red: 0.161, green: 0.718, blue: 0.525, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: DashboardSelectionCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: DashboardSelectionCell.cellIdentifier)
        
        secureLottieView.loopMode = .loop
        secureLottieView.play()
        secureLabel.textColor = UIColor(red: 0, green: 0.263, blue: 0.318, alpha: 1)
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: DashboardSelectionCell.cellIdentifier, for: indexPath) as! DashboardSelectionCell
        cell.configure(selection: selections[indexPath.row])
        cell.layoutSubviews()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in selections {
            item.isSelected = false
        }
        
        selections[indexPath.row].isSelected = true
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selections[indexPath.row].title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 30, height: 40)
    }
}


