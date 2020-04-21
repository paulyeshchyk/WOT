//
//  WOTWebResponseAdapterModuleTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterModuleTree: WOTWebResponseAdapter {
    private lazy var currentContext: NSManagedObjectContext  = {
        return WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) )  -> CoreDataStoreProtocol {
        self.logInspector.log(CreateLog("CoreDataStore for: \(request.description)"), sender: nil)

        let store = CoreDataStore(Clazz: ModulesTree.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext, logInspector: logInspector)
        store.onGetIdent = { Clazz, json, key in
            let ident: Any
            if let primaryKeyPath = Clazz.primaryKeyPath() {
                ident = json[primaryKeyPath] ?? key
            } else {
                ident = key
            }
            return ident
        }
        store.logInspector = self.logInspector
        store.onFinishJSONParse = onFinish
//        store.perform()
        return store
    }
}
