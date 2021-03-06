//
//  ListSetting+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/1/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData
import Foundation

extension ListSetting {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListSetting> {
        return NSFetchRequest<ListSetting>(entityName: "ListSetting")
    }

    @NSManaged public var ascending: NSNumber?
    @NSManaged public var key: String?
    @NSManaged public var orderBy: NSNumber?
    @NSManaged public var type: String?
    @NSManaged public var values: String?
}
