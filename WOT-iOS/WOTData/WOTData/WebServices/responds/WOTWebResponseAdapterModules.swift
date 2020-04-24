//
//  WOTWebResponseAdapterModules.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterModules: WOTWebResponseAdapter {
    public let Clazz: PrimaryKeypathProtocol.Type = Module.self

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, subordinateLinks: [WOTJSONLink]?, externalCallback: NSManagedObjectCallback?, onFinish: @escaping ( (Error?) -> Void ) ) -> CoreDataStoreProtocol {
        let store = CoreDataStore(Clazz: Clazz, request: request, binary: binary, linkAdapter: jsonLinkAdapter, appManager: appManager, extenalLinks: subordinateLinks)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onFinishJSONParse = onFinish
        store.onCreateNSManagedObject = externalCallback
        return store
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let primaryKeyPath = Clazz.primaryKeyPath()
        let ident = json[primaryKeyPath] ?? key
        return ident
    }
}
