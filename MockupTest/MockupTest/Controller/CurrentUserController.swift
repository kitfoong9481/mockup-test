//
//  UserController.swift
//  MockupTest
//
//  Created by Kit Foong on 08/06/2023.
//

import Foundation
import CoreData

public class CurrentUserController {
    public func registerUser(user: User, complete: @escaping((_ status: Bool, _ message: String?) -> Void)) {
        let userFetch: NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(userFetch)
            
            if results.count > 0 {
                // user registered
                let currentUser = results.first
                
                if currentUser?.email == user.email && currentUser?.loginType == user.loginType {
                    complete(false, "User already registered. Please proceed to Sign In")
                    return
                }
                
                currentUser?.setValue(user.username, forKey: #keyPath(CurrentUser.username))
                currentUser?.setValue(user.email, forKey: #keyPath(CurrentUser.email))
                currentUser?.setValue(user.loginType == 1 ? user.password : "", forKey: #keyPath(CurrentUser.password))
                currentUser?.setValue(user.loginType, forKey: #keyPath(CurrentUser.loginType))
                currentUser?.setValue(true, forKey: #keyPath(CurrentUser.isLogin))
                currentUser?.setValue(Date(), forKey: #keyPath(CurrentUser.updateTime))
            } else {
                // new user
                let newUser = CurrentUser(context: managedContext)
                newUser.setValue(user.email, forKey: #keyPath(CurrentUser.email))
                newUser.setValue(user.loginType == 1 ? user.password : "", forKey: #keyPath(CurrentUser.password))
                newUser.setValue(user.loginType, forKey: #keyPath(CurrentUser.loginType))
                newUser.setValue(true, forKey: #keyPath(CurrentUser.isLogin))
                newUser.setValue(Date(), forKey: #keyPath(CurrentUser.updateTime))
            }
            
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            complete(true, "Register Successful")
        } catch let error as NSError {
            complete(false, "Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    public func signInUser(user: User, complete: @escaping(( _ status: Bool, _ message: String?) -> Void)) {
        let userFetch: NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(userFetch)
            
            if results.count > 0 {
                // user registered
                let currentUser = results.first
                
                if currentUser?.email != user.email && currentUser?.password != user.password {
                    complete(false, "Invalid email or password")
                    return
                }
                
                if user.loginType != 3 {
                    if currentUser?.email == user.email && currentUser?.loginType != user.loginType {
                        complete(false, "Invalid login method")
                        return
                    }
                } else {
                    if currentUser?.loginType != user.loginType {
                        complete(false, "Invalid login method")
                        return
                    }
                }
                
                currentUser?.setValue(currentUser?.username, forKey: #keyPath(CurrentUser.username))
                currentUser?.setValue(currentUser?.email, forKey: #keyPath(CurrentUser.email))
                currentUser?.setValue(currentUser?.password, forKey: #keyPath(CurrentUser.password))
                currentUser?.setValue(user.loginType, forKey: #keyPath(CurrentUser.loginType))
                currentUser?.setValue(true, forKey: #keyPath(CurrentUser.isLogin))
                currentUser?.setValue(Date(), forKey: #keyPath(CurrentUser.updateTime))
            } else {
                if user.loginType == 1 {
                    complete(false, "User does not exist. Please sign up first")
                    return
                }
                
                let newUser = CurrentUser(context: managedContext)
                newUser.setValue(user.username, forKey: #keyPath(CurrentUser.username))
                newUser.setValue(user.email, forKey: #keyPath(CurrentUser.email))
                newUser.setValue("", forKey: #keyPath(CurrentUser.password))
                newUser.setValue(user.loginType, forKey: #keyPath(CurrentUser.loginType))
                newUser.setValue(true, forKey: #keyPath(CurrentUser.isLogin))
                newUser.setValue(Date(), forKey: #keyPath(CurrentUser.updateTime))
            }
            
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
            complete(false, "Login Successful")
        } catch let error as NSError {
            complete(false, "Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    public func fetchUser(complete: @escaping(( _ user: CurrentUser?, _ status: Bool, _ message: String?) -> Void)) {
        let userFetch: NSFetchRequest<CurrentUser> = CurrentUser.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(userFetch)
            
            if results.count > 0 {
                complete(results.first!, true, "")
            } else {
                complete(nil, false, "User does not login")
            }
        } catch let error as NSError {
            complete(nil, false, "Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    public func checkUserIsLogin(complete: @escaping(( _ isLogin: Bool) -> Void))  {
        var isLogin = false
        
        fetchUser(complete: { (user, status, message) in
            if status {
                isLogin = user!.isLogin
            }
            
            complete(isLogin)
        })
    }
}
