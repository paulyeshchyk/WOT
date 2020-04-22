//
//  WOTWebResponseAdapter.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterTurrets: WOTWebResponseAdapter {
    public let Clazz: PrimaryKeypathProtocol.Type = VehicleprofileTurret.self

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) -> CoreDataStoreProtocol {
        self.logInspector.log(CreateLog("CoreDataStore for: \(request.description)"), sender: nil)

        let store = CoreDataStore(Clazz: Clazz, request: request, binary: binary, linkAdapter: jsonLinkAdapter, appManager: appManager)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onFinishJSONParse = onFinish
        return store
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        if let primaryKeyPath = Clazz.primaryKeyPath() {
            ident = json[primaryKeyPath] ?? key
        } else {
            ident = key
        }
        return ident
    }
}
