//
//  WOTWebResponseAdapterProfile.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 3/11/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterProfile: WOTWebResponseAdapter {
    public let Clazz: AnyClass = Vehicleprofile.self
    public let PrimaryKeypath: String  = #keyPath(Vehicleprofile.hashName)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return Vehicleprofile.primaryKey(for: ident)
    }

    private lazy var currentContext: NSManagedObjectContext  = {
        return WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) {
        let store = CoreDataStore(Clazz: VehicleprofileRadio.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext)
        store.onGetIdent = { Clazz, json, key in
            let ident: Any
            if let primaryKeyPath = Clazz.primaryKeyPath() {
                ident = (json[primaryKeyPath] as? JSON)?.asURLQueryString().hashValue ?? key
            } else {
                ident = key
            }
            return ident
        }
        store.onFinishJSONParse = onFinish
        store.perform()
    }
}
