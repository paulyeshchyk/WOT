//
//  WOTWebResponseAdapterProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterProfile: WOTWebResponseAdapter {
    public let Clazz: PrimaryKeypathProtocol.Type = Vehicleprofile.self

    override public func request(_ request: WOTRequestProtocol, parseData data: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol?, onCreateNSManagedObject: NSManagedObjectOptionalCallback?, onFinish: @escaping OnParserDidFinish) -> JSONCoordinatorProtocol {
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
            ident = (json[primaryKeyPath] as? JSON)?.asURLQueryString().hashValue ?? key
        } else {
            ident = key
        }
        return ident
    }
}
