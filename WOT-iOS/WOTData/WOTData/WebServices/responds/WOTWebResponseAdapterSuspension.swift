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
    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapter) -> Error? {
        return binary?.parseAsJSON { (json) in

            guard let json = json, json.keys.count != 0 else {
                print("no json for \(type(of: self))")
                return
            }

            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            context.perform {
                json.keys.forEach { (key) in
                    guard let suspension = json[key] as? [AnyHashable: Any] else { return }
                    guard let tag = suspension[#keyPath(VehicleprofileSuspension.tag)] as? String else { return }
                    let suspensionPK = WOTPrimaryKey(name: #keyPath(VehicleprofileSuspension.tag), value: tag as AnyObject, predicateFormat: "%K == %@")
                    let predicate = NSPredicate(format: "%K == %@", #keyPath(VehicleprofileSuspension.tag), tag)
                    let newObject = NSManagedObject.findOrCreateObject(forClass: VehicleprofileSuspension.self, predicate: predicate, context: context)
                    newObject?.mapping(fromJSON: suspension, into: context, parentPrimaryKey: suspensionPK, linksCallback: { links in
                        jsonLinkAdapter.request(request, adoptJsonLinks: links)
                    })
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
