//
//  NewAccount.swift
//  MockupTest
//
//  Created by Kit Foong on 10/06/2023.
//

// Account Type
// 1 - Login
// 2 - Card
// 3 - Others

import Foundation

public class NewAccount {
    var accountType: Int32 = 1
    var webName: String = ""
    var url: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    
    init(accountType: Int32, webName: String, url: String, username: String, email: String, password: String) {
        self.accountType = accountType
        self.webName = webName
        self.url = url
        self.username = username
        self.email = email
        self.password = password
    }
}
