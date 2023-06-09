//
//  CurrentUser.swift
//  MockupTest
//
//  Created by Kit Foong on 08/06/2023.
//

import Foundation

public class User {
    var userID: String = ""
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var loginType: Int32 = 1
    
    init(userID: String, username: String, email: String, password: String, loginType: Int32) {
        self.userID = userID
        self.username = username
        self.email = email
        self.password = password
        self.loginType = loginType
    }
}
