//
//  WOTWebResponseAdapterSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTWebResponseAdapterSuspension: NSObject, WOTWebResponseAdapter {
    public func parseData(_ binary: Data?, error: Error?, jsonLinksCallback: WOTJSONLinksCallback?) -> Error? {
        return binary?.parseAsJSON { (json) in

            guard let keys = json?.keys, keys.count != 0 else {
                return
            }

            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            context.perform {
                keys.forEach { (key) in
                    guard let suspension = json?[key] as? [AnyHashable: Any] else { return }
                    guard let tag = suspension[#keyPath(VehicleprofileSuspension.tag)] as? String else { return }
                    let predicate = NSPredicate(format: "%K == %@", #keyPath(VehicleprofileSuspension.tag), tag)
                    guard let newObject = NSManagedObject.findOrCreateObject(forClass: VehicleprofileSuspension.self, predicate: predicate, context: context) as? VehicleprofileSuspension else { return }
                    let suspensionPK = PrimaryKey(name: #keyPath(VehicleprofileSuspension.tag), value: tag as AnyObject, predicateFormat: "%K == %@")
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
