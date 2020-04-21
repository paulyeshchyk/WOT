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

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) )  -> CoreDataStoreProtocol {
        self.logInspector.log(CreateLog("CoreDataStore for: \(request.description)"), sender: nil)

        let store = CoreDataStore(Clazz: VehicleprofileRadio.self, request: request, binary: binary, linkAdapter: jsonLinkAdapter, context: currentContext, logInspector: logInspector)
        store.onGetIdent = onGetIdent(_:_:_:)
        store.logInspector = self.logInspector
        store.onFinishJSONParse = onFinish
        return store
    }

    private func onGetIdent(_ Clazz: PrimaryKeypathProtocol.Type, _ json: JSON, _ key: AnyHashable) -> Any {
        let ident: Any
        if let primaryKeyPath = Clazz.primaryKeyPath() {
            ident = (json[primaryKeyPath] as? JSON)?.asURLQueryString().hashValue ?? key
        } else {
            ident = key
        }
        return ident
    }
}
