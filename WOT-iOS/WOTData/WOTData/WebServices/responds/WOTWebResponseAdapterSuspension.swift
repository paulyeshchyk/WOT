//
//  WOTWebResponseAdapterSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterSuspension: WOTWebResponseAdapter {
    public let Clazz: AnyClass = VehicleprofileSuspension.self
    public let PrimaryKeypath: String  = #keyPath(VehicleprofileSuspension.tag)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return VehicleprofileSuspension.primaryKey(for: ident)
    }

    public override func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol) -> Error? {
        return binary?.parseAsJSON({ json in
            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            json?.keys.forEach { (ident) in
                guard
                    let objectById = json?[ident] as? JSON,
                    let objectJson = objectById["suspension"] as? JSON
                else {
                    return
                }
                context.perform {
                    if
                        let primaryKey = self.primaryKey(for: ident as AnyObject),
                        let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: primaryKey.predicate, context: context) {
                        managedObject.mapping(fromJSON: objectJson, parentPrimaryKey: primaryKey, onSubordinateCreate: nil, linksCallback: { links in
                            jsonLinkAdapter.request(request, adoptJsonLinks: links)
                    })
                        context.tryToSave()
                    }
                }
            }
        })
    }
}
