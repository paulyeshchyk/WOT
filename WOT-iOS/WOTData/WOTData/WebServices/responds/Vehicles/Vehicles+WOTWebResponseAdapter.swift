//
//  WOTWebResponseAdapterVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class VehiclesAdapter: NSObject, WOTWebResponseAdapter {
    public func request(_ request: WOTRequestProtocol, parseData binary: Data?, jsonLinkAdapter: JSONLinksAdapter) -> Error? {
        return binary?.parseAsJSON({ json in

            guard let keys = json?.keys, keys.count != 0 else {
                return
            }

            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            keys.forEach { (key) in
                guard let vehiclesJSON = json?[key] as? JSON else { return }
                guard let tag = vehiclesJSON[#keyPath(Vehicles.tag)] as? String else { return }

                let vehiclesPK = PrimaryKey(name: #keyPath(Vehicles.tag), value: tag as AnyObject, predicateFormat: "%K == %@")
                context.perform {
                    guard let vehicle = NSManagedObject.findOrCreateObject(forClass: Vehicles.self, predicate: vehiclesPK.predicate, context: context) as? Vehicles else { return }
                    vehicle.mapping(fromJSON: vehiclesJSON, into: context, parentPrimaryKey: vehiclesPK, linksCallback: { links in
                        jsonLinkAdapter.request(request, adoptJsonLinks: links)
                    })
                    context.tryToSave()
                }
            }
        })
    }
}
