//
//  WOTWebResponseAdapterRadios.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterRadios: WOTWebResponseAdapter {
    public let Clazz: AnyClass = VehicleprofileRadio.self
    public let PrimaryKeypath: String  = #keyPath(VehicleprofileRadio.tag)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return VehicleprofileRadio.primaryKey(for: ident)
    }

    private lazy var currentContext: NSManagedObjectContext  = {
        return WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) {
        let store = CoreDataStore(Clazz: VehicleprofileRadio.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext)
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
