//
//  WOTWebResponseAdapterSuspension.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/13/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterSuspension: WOTWebResponseAdapter {
    public let Clazz: AnyClass = VehicleprofileSuspension.self
    public let PrimaryKeypath: String  = #keyPath(VehicleprofileSuspension.tag)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return VehicleprofileSuspension.primaryKey(for: ident)
    }

    private lazy var currentContext: NSManagedObjectContext  = {
        return WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
    }()

    override public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapterProtocol, subordinateLinks: [WOTJSONLink]?, onFinish: @escaping ( (Error?) -> Void ) ) {
        let error = binary?.parseAsJSON({ json in
            let context = self.currentContext
            json?.keys.forEach { (key) in
                guard
                    let objectJson = json?[key] as? JSON,
                    let objectJson1 = objectJson["suspension"] as? JSON
                else {
                    return
                }
                let primaryKey = self.primaryKey(for: key as AnyObject)
                let pkCase = PKCase()
                pkCase[.primary] = primaryKey

                context.perform {
                    if
                        let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: primaryKey?.predicate, context: context) {
                        managedObject.mapping(fromJSON: objectJson1, pkCase: pkCase, onSubordinateCreate: nil, linksCallback: { links in
                            jsonLinkAdapter.request(request, adoptJsonLinks: links)
                    })
                        context.tryToSave()
                    }
                }
            }
        })
        onFinish(error)
    }
}
