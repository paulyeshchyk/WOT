//
//  NSManagedObject+ManagedObjectProtocol.swift
//  WOTKit
//
//  Created by Paul on 19.12.22.
//  Copyright © 2022 Pavel Yeshchyk. All rights reserved.
//

import CoreData

extension NSManagedObject: ManagedObjectProtocol {
    public var entityName: String {
        return entity.name ?? "<unknown>"
    }
}

