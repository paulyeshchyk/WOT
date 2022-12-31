//
//  UserSession+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension UserSession {
    @nonobjc class func fetchRequest() -> NSFetchRequest<UserSession> {
        return NSFetchRequest<UserSession>(entityName: "UserSession")
    }

    @NSManaged var access_token: String?
    @NSManaged var accound_id: String?
    @NSManaged var currentSession: NSNumber?
    @NSManaged var expires_at: NSNumber?
    @NSManaged var isCurrent: NSNumber?
    @NSManaged var nickname: String?
}
