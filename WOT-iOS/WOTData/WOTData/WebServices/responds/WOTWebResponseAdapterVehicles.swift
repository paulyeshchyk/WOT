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
    private lazy var currentContext: NSManagedObjectContext  = {
        let coordinator = WOTTankCoreDataProvider.sharedInstance.persistentStoreCoordinator
        return self.workManagedObjectContext(coordinator: coordinator)
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol) -> Error? {
        var store = CoreDataStore(Clazz: Vehicles.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext)
        store.onGetIdent = { Clazz, json, key in
            let primaryKeyPath = Clazz.primaryKeyPath()
            let ident = json[primaryKeyPath] ?? key
            return ident
        }
        store.perform()
        return nil
    }
}
