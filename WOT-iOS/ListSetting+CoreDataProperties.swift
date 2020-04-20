//
//  ListSetting+CoreDataProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/20/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

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
