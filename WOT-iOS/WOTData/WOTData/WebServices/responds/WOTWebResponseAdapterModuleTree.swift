//
//  WOTWebResponseAdapterModuleTree.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/10/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterModuleTree: WOTWebResponseAdapter {
    public let Clazz: PrimaryKeypathProtocol.Type = ModulesTree.self

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, subordinateLinks: [WOTJSONLink]?, externalCallback: NSManagedObjectCallback?, onFinish: @escaping ( (Error?) -> Void ) ) -> CoreDataStoreProtocol {
        let store = CoreDataStore(Clazz: Clazz, request: request, linkAdapter: jsonLinkAdapter, appManager: appManager, extenalLinks: subordinateLinks)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onFinishJSONParse = onFinish
        store.onCreateNSManagedObject = externalCallback
        return store
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        let primaryKeyPath = Clazz.primaryKeyPath()
        #warning("check the case")
        if  primaryKeyPath.count > 0 {
            ident = json[primaryKeyPath] ?? key
        } else {
            ident = key
        }
        return ident
    }
}
