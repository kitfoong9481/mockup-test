//
//  CurrentUser.swift
//  MockupTest
//
//  Created by Kit Foong on 08/06/2023.
//

// Login Type
// 1 - Mobile
// 2 - Google
// 3 - Apple

import Foundation

public class User {
    var userId: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var loginType: Int32 = 1
    
    init(userId: String, username: String, email: String, password: String, loginType: Int32) {
        self.userId = userId
        self.username = username
        self.email = email
        self.password = password
        self.loginType = loginType
    }
}
