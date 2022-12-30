//
//  ListSetting+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData

public extension ListSetting {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ListSetting> {
        return NSFetchRequest<ListSetting>(entityName: "ListSetting")
    }

    @NSManaged var ascending: NSNumber?
    @NSManaged var key: String?
    @NSManaged var orderBy: NSNumber?
    @NSManaged var type: String?
    @NSManaged var values: String?
}
