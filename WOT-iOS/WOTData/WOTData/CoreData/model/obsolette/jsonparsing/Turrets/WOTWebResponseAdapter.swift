//
//  WOTWebResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterTurrets: NSObject, WOTWebResponseAdapter {

    public func parseData(_ binary: Data?, error: Error?, nestedRequestsCallback: JSONMappingCompletion?) -> Error? {

        return binary?.parseAsJSON { (json) in

            guard let tankTurretsDictionary = json?[WGJsonFields.data] as? Dictionary<AnyHashable, Any> else {
                return
            }
            let tankTurretsKeysArray = tankTurretsDictionary.keys
            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            context.perform {
                tankTurretsKeysArray.forEach {
                    if let json = tankTurretsDictionary[$0] as? Dictionary<AnyHashable, Any> {
                        let predicate = NSPredicate(format: "%K == %@", WGJsonFields.module_id, json[WGJsonFields.module_id] as? String ?? "")
                        if let turrets = Tankturrets.findOrCreateObject(predicate: predicate, context: context) as? Tankturrets {
                            turrets.mapping(fromJSON: json, into: context, completion: nil)
                        }
                    }
                }
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        
                    }
                }
            }
        }
    }
}
