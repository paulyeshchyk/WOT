//
//  WOTWebResponseAdapterVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterVehicles: WOTWebResponseAdapter {
    public let Clazz: AnyClass = Vehicles.self
    public let PrimaryKeypath: String  = #keyPath(Vehicles.tag)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return Vehicles.primaryKey(for: ident)
    }

    private lazy var currentContext: NSManagedObjectContext  = {
        let coordinator = WOTTankCoreDataProvider.sharedInstance.persistentStoreCoordinator
        return self.workManagedObjectContext(coordinator: coordinator)
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol) -> Error? {
        return binary?.parseAsJSON({ json in
            let context = self.currentContext
            json?.keys.forEach { (key) in
                guard
                    let objectJson = json?[key] as? JSON,
                    let ident = objectJson[self.PrimaryKeypath]
                else {
                    return
                }

                let onSubordinateCreate: OnSubordinateCreateCallback = { clazz, primaryKey in
                    let managedObject = NSManagedObject.findOrCreateObject(forClass: clazz, predicate: primaryKey?.predicate, context: context)
                    return managedObject
                }

                let onLinksCallback: OnLinksCallback = { links in
                    jsonLinkAdapter.request(request, adoptJsonLinks: links)
                }

                context.perform {
                    if
                        let primaryKey = self.primaryKey(for: ident as AnyObject),
                        let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: primaryKey.predicate, context: context) {
                        managedObject.mapping(fromJSON: objectJson, parentPrimaryKey: primaryKey, onSubordinateCreate: onSubordinateCreate, linksCallback: onLinksCallback)
                        context.tryToSave()
                    }
                }
            }
        })
    }
}
