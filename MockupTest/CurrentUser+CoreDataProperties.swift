//
//  CurrentUser+CoreDataProperties.swift
//  
//
//  Created by Kit Foong on 08/06/2023.
//
//

import Foundation
import CoreData

extension CurrentUser {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentUser> {
        return NSFetchRequest<CurrentUser>(entityName: "CurrentUser")
    }
    
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var loginType: Int32
    @NSManaged public var isLogin: Bool
    @NSManaged public var updateTime: Date?
    @NSManaged public var userId: String?
}
