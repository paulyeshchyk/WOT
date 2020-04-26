//
//  WOTWebResponseAdapterSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterSuspension: WOTWebResponseAdapter {
    public let Clazz: PrimaryKeypathProtocol.Type = VehicleprofileSuspension.self

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectCallback?, onFinish: @escaping ( (Error?) -> Void ) ) -> JSONCoordinatorProtocol {
        let store = JSONCoordinator(Clazz: Clazz, request: request, linkAdapter: jsonLinkAdapter, appManager: appManager)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.onFinishJSONParse = onFinish
        store.onCreateNSManagedObject = onCreateNSManagedObject
        return store
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        let primaryKeyPath = Clazz.primaryKeyPath()
        #warning("check the case")
        if  primaryKeyPath.count > 0 {
            ident = json[primaryKeyPath] ?? key//json[primaryKeyPath].objectJson["suspension"]
        } else {
            ident = key
        }
        return ident
    }
}
