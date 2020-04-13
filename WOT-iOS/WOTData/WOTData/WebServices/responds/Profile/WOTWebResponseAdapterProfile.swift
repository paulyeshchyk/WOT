//
//  WOTWebResponseAdapterProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterProfile: NSObject, WOTWebResponseAdapter {
    public func parseData(_ data: Data?, jsonLinksCallback: WOTJSONLinksCallback?) -> Error? {
        return  data?.parseAsJSON({ (json) in

            guard let keys = json?.keys, keys.count != 0 else {
                return
            }

            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            context.perform {
                keys.forEach { (key) in

                    guard let profile = json?[key] as? [AnyHashable: Any] else { return }
                    let profilehash = profile.asURLQueryString().hashValue
                    let predicate = NSPredicate(format: "%K = %d", WOT_KEY_HASHNAME, profilehash)
                    if let vehicleProfile = NSManagedObject.findOrCreateObject(forClass: Vehicleprofile.self, predicate: predicate, context: context) as? Vehicleprofile {
                        vehicleProfile.hashName = NSDecimalNumber(value: profilehash)
                        #warning("wrong PK")
                        let primaryKey = PrimaryKey(name: WOT_KEY_HASHNAME, value: String(profilehash) as AnyObject, predicateFormat: "%K == %@")
                        vehicleProfile.mapping(fromJSON: profile, into: context, parentPrimaryKey: primaryKey, jsonLinksCallback: jsonLinksCallback)
                    }
                }

                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("\(#file) \(#function) at \(error.localizedDescription)")
                    }
                }
            }
        })
    }
}
