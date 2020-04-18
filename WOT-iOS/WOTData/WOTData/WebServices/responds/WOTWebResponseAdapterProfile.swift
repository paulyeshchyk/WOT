//
//  WOTWebResponseAdapterProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterProfile: WOTWebResponseAdapter {
    public let Clazz: AnyClass = Vehicleprofile.self
    public let PrimaryKeypath: String  = #keyPath(Vehicleprofile.hashName)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return Vehicleprofile.primaryKey(for: ident)
    }

    private lazy var currentContext: NSManagedObjectContext  = {
        let coordinator = WOTTankCoreDataProvider.sharedInstance.persistentStoreCoordinator
        return self.workManagedObjectContext(coordinator: coordinator)
    }()

    public override func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol) -> Error? {
        return binary?.parseAsJSON({ (json) in
            let context = self.currentContext
            json?.keys.forEach { (key) in
                guard let objectJson = json?[key] as? [AnyHashable: Any] else { return }
                let ident = objectJson.asURLQueryString().hashValue
                guard let predicate = Vehicleprofile.predicate(for: ident as AnyObject) else { return }
                context.perform {
                    if
                        let managedObject = NSManagedObject.findOrCreateObject(forClass: Vehicleprofile.self, predicate: predicate, context: context) as? Vehicleprofile,
                        let primaryKey = Vehicleprofile.primaryKey(for: ident as AnyObject) {
                        managedObject.hashName = NSDecimalNumber(value: ident)

                        managedObject.mapping(fromJSON: objectJson, parentPrimaryKey: primaryKey, onSubordinateCreate: nil, linksCallback: { links in
                            jsonLinkAdapter.request(request, adoptJsonLinks: links)
                        })
                    }
                    context.tryToSave()
                }
            }
        })
    }
}
