//
//  WOTWebResponseAdapterEngines.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterEngines: WOTWebResponseAdapter {
    public let Clazz: AnyClass = VehicleprofileEngine.self
    public let PrimaryKeypath: String  = #keyPath(VehicleprofileEngine.tag)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return VehicleprofileEngine.primaryKey(for: ident)
    }

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) )  -> CoreDataStoreProtocol {
        self.logInspector.log(CreateLog("CoreDataStore for: \(request.description)"), sender: nil)

        let store = CoreDataStore(Clazz: VehicleprofileRadio.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, appManager: appManager)
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
