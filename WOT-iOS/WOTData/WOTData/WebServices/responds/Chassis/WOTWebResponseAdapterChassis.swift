//
//  WOTWebResponseAdapterChassis.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTWebResponseAdapterChassis: NSObject, WOTWebResponseAdapter {
    public func parseData(_ binary: Data?, jsonLinksCallback: WOTJSONLinksCallback?) -> Error? {
        return binary?.parseAsJSON { (json) in

            guard let keys = json?.keys, keys.count != 0 else {
                return
            }

            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            context.perform {
                keys.forEach { (key) in
                    guard let suspension = json?[key] as? [AnyHashable: Any] else { return }
                    guard let module_id = suspension[WGJsonFields.module_id] as? AnyObject else { return }
                    let suspensionPK = PrimaryKey(name: #keyPath(Tankchassis.module_id), value: module_id, predicateFormat: "%K == %@")
                    guard let newObject = NSManagedObject.findOrCreateObject(forClass: Tankchassis.self, predicate: suspensionPK.predicate, context: context) as? Tankchassis else { return }
                    newObject.mapping(fromJSON: suspension, into: context, parentPrimaryKey: suspensionPK, jsonLinksCallback: jsonLinksCallback)
                }

                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("\(#file) \(#function) at \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
