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
import EzPopup

class DashboardViewController: TSViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var searhButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var secureView: UIView!
    @IBOutlet weak var secureLottieView: LottieAnimationView!
    @IBOutlet weak var secureLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var selections: [DashboardSelection] = [DashboardSelection(title: "All Accounts", isSelected: true), DashboardSelection(title: "Login"), DashboardSelection(title: "Card"), DashboardSelection(title: "Others")]
    
    var currentUser: CurrentUser!
    var accounts: [Account] = []
    var selectedLoginType: Int32 = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAccounts()
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
    
    func fetchAccounts() {
        AccountController().fetchAccounts(accountType: self.selectedLoginType, complete: { (accounts, status, message) in
            if status {
                self.accounts = accounts
                if self.accounts.count > 0 {
                    self.secureView.makeHidden()
                    self.tableView.makeVisible()
                    self.tableView.reloadData()
                } else {
                    self.secureView.makeVisible()
                    self.tableView.makeHidden()
                }
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
        
        addButton.circleCorner()
        addButton.backgroundColor = UIColor(red: 0.161, green: 0.718, blue: 0.525, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: DashboardSelectionCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: DashboardSelectionCell.cellIdentifier)
        
        secureLottieView.loopMode = .loop
        secureLottieView.play()
        secureLabel.textColor = UIColor(red: 0, green: 0.263, blue: 0.318, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: AccountTableViewCell.cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: AccountTableViewCell.cellIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    @IBAction func addAccountAction(_ sender: Any) {
        let vc : AddAccountViewController = self.storyboard?.instantiateViewController(withIdentifier: "addAccount") as! AddAccountViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCell(withReuseIdentifier: DashboardSelectionCell.cellIdentifier, for: indexPath) as! DashboardSelectionCell
        cell.selection = selections[indexPath.row]
        cell.configure(selection: selections[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in selections {
            item.isSelected = false
        }
        
        selections[indexPath.row].isSelected = true
        selectedLoginType = Int32(indexPath.row)
        collectionView.reloadData()
        fetchAccounts()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: selections[indexPath.row].title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width + 30, height: 40)
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.cellIdentifier, for: indexPath) as! AccountTableViewCell
        cell.configure(account: accounts[indexPath.row])
        cell.currentIndex = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            completionHandler(true)
            self.showDeleteAccAlert(index: indexPath.row)
        }
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func showDeleteAccAlert(index: Int) {
        let alert = UIAlertController(title: "Delete Items", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)

        let remove = UIAlertAction(title: "Remove" , style: .default) { (_ action) in
            if self.accounts.indices.contains(index) {
                AccountController().deleteAccount(account: self.accounts[index], complete: { (status, message) in
                    self.view.makeToast(message, duration: 2, position: CSToastPositionCenter)
                    
                    if status {
                        self.fetchAccounts()
                    }
                })
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel" , style: .default) { (_ action) in

        }
    
        alert.addAction(cancel)
        alert.addAction(remove)

        present(alert, animated: true, completion: nil)
    }
}

extension DashboardViewController: AccountCellDelegate {
    func moreOnTap(for index: Int) {
        if accounts.indices.contains(index) {
            let accountSelectionView = AccountSelectionView(account: accounts[index])
            accountSelectionView.currentIndex = index
            let popupVC = PopupViewController(contentView: accountSelectionView, popupWidth: 316, popupHeight: 181)
            present(popupVC, animated: true)
        }
    }
}



