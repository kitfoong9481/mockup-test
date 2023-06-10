//
//  AccountController.swift
//  MockupTest
//
//  Created by Kit Foong on 10/06/2023.
//

import Foundation
import CoreData

public class AccountController {
    public func checkExistUser(email: String, complete: @escaping((_ status: Bool, _ message: String?) -> Void)) {
        let accountFetch: NSFetchRequest<Account> = Account.fetchRequest()
        accountFetch.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(accountFetch)
            
            if results.count > 0 {
                complete(false, "Accont already exist")
            } else {
                complete(true, nil)
            }
        } catch let error as NSError {
            complete(false, "Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    public func createNewAccount(account: NewAccount, complete: @escaping((_ status: Bool, _ message: String?) -> Void)) { 
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newAccount = Account(context: managedContext)
        newAccount.setValue(account.accountType, forKey: #keyPath(Account.accountType))
        newAccount.setValue(account.webName, forKey: #keyPath(Account.webName))
        newAccount.setValue(account.url, forKey: #keyPath(Account.url))
        newAccount.setValue(account.username, forKey: #keyPath(Account.username))
        newAccount.setValue(account.email, forKey: #keyPath(Account.email))
        newAccount.setValue(account.password, forKey: #keyPath(Account.password))
        newAccount.setValue(Date(), forKey: #keyPath(Account.createdAt))
        newAccount.setValue(Date(), forKey: #keyPath(Account.updatedAt))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        complete(true, "Register Successful")
    }
    
    public func fetchAccounts(accountType: Int32, complete: @escaping((_ accounts: [Account], _ status: Bool, _ message: String?) -> Void)) {
        let accountFetch: NSFetchRequest<Account> = Account.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        
        if accountType != 0 {
            accountFetch.predicate = NSPredicate(format: "accountType == %i", accountType)
        }
        
        accountFetch.sortDescriptors = [sortDescriptor]
        
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(accountFetch)
            
            complete(results, true, nil)
        } catch let error as NSError {
            complete([], false, "Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    public func deleteAccount(account: Account, complete: @escaping(( _ status: Bool, _ message: String?) -> Void)) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        managedContext.delete(account)
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        complete(true, "Delete Account successful")
    }
}
