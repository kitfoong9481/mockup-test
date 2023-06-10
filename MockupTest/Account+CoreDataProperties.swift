//
//  Account+CoreDataProperties.swift
//  
//
//  Created by Kit Foong on 10/06/2023.
//
//

import Foundation
import CoreData


extension Account {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
        return NSFetchRequest<Account>(entityName: "Account")
    }

    @NSManaged public var email: String?
    @NSManaged public var accountType: Int32
    @NSManaged public var password: String?
    @NSManaged public var url: String?
    @NSManaged public var username: String?
    @NSManaged public var webName: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?

}
