//
//  NSManagedObject+MD5.swift
//  WOTApi
//
//  Created by Paul on 3.01.23.
//

import CoreData

extension NSManagedObject: MD5Protocol {
    public var MD5: String { do { return try objectID.description.MD5() } catch { return "" } }
}
