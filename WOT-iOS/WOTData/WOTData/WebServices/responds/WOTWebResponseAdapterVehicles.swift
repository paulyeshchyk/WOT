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
        return WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) {
        let store = CoreDataStore(Clazz: Vehicles.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext)
        store.onGetIdent = { Clazz, json, key in
            let ident: Any
            if let primaryKeyPath = Clazz.primaryKeyPath() {
                ident = json[primaryKeyPath] ?? key
            } else {
                ident = key
            }
            return ident
        }
        store.onFinishJSONParse = onFinish
        store.perform()
    }
}
