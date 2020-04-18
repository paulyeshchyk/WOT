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
        let store = CoreDataStore(Clazz: Vehicles.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext)
        store.perform()
        return nil
    }
}
