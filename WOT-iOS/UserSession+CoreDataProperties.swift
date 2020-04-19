//
//  UserSession+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

extension UserSession {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSession> {
        return NSFetchRequest<UserSession>(entityName: "UserSession")
    }

    @NSManaged public var access_token: String?
    @NSManaged public var accound_id: String?
    @NSManaged public var currentSession: NSNumber?
    @NSManaged public var expires_at: NSNumber?
    @NSManaged public var isCurrent: NSNumber?
    @NSManaged public var nickname: String?
}
