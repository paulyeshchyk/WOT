//
//  WOTWebResponseAdapterModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterModules: WOTWebResponseAdapter {
    private lazy var currentContext: NSManagedObjectContext  = {
        return WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) {
        var store = CoreDataStore(Clazz: Module.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext)
        store.onGetIdent = { Clazz, json, key in
            let primaryKeyPath = Clazz.primaryKeyPath()
            let ident = json[primaryKeyPath] ?? key
            return ident
        }
        store.onFinishJSONParse = onFinish
        store.perform()
    }
}
