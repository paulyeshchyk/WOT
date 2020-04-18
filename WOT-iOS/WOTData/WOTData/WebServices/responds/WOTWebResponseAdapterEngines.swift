//
//  WOTWebResponseAdapterEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterEngines: NSObject, WOTWebResponseAdapter {
    public let Clazz: AnyClass = Tankengines.self
    public let PrimaryKeypath: String  = #keyPath(Tankengines.module_id)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return Tankengines.primaryKey(for: ident)
    }

    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapter) -> Error? {
        return binary?.parseAsJSON({ json in
            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            json?.keys.forEach { (key) in
                guard
                    let objectJson = json?[key] as? JSON,
                    let ident = objectJson[self.PrimaryKeypath]
                else {
                    return
                }
                context.perform {
                    if
                        let primaryKey = self.primaryKey(for: ident as AnyObject),
                        let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: primaryKey.predicate, context: context)                         {
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
