//
//  WOTWebResponseAdapterGuns.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/18/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public class WOTWebResponseAdapterGuns: WOTWebResponseAdapter {
    public let Clazz: AnyClass = VehicleprofileGun.self
    public let PrimaryKeypath: String  = #keyPath(VehicleprofileGun.tag)

    public func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        return VehicleprofileGun.primaryKey(for: ident)
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
                    let ident = objectJson[self.PrimaryKeypath]
                else {
                    return
                }

                let primaryKey = self.primaryKey(for: ident as AnyObject)
                let pkCase = PKCase()
                pkCase[.primary] = primaryKey

                context.perform {
                    if
                        let predicate = primaryKey?.predicate,
                        let managedObject = NSManagedObject.findOrCreateObject(forClass: self.Clazz, predicate: predicate, context: context) {
                        managedObject.mapping(fromJSON: objectJson, pkCase: pkCase,onSubordinateCreate: nil, linksCallback: { links in
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
