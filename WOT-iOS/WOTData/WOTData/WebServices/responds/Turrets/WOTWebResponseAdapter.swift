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
    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapter) -> Error? {
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
                        if let turrets = Tankturrets.findOrCreateObject(predicate: predicate, context: context) as? Tankturrets, let module_id = turrets.module_id {
                            let turretPK = WOTPrimaryKey(name: #keyPath(Tankturrets.module_id), value: module_id, predicateFormat: "%K == %@")
                            turrets.mapping(fromJSON: json, into: context, parentPrimaryKey: turretPK, linksCallback: { links in
                                jsonLinkAdapter.request(request, adoptJsonLinks: links)
                            })
                        }
                    }
                }
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {}
                }
            }
        }
    }
}
