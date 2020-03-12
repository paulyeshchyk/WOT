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
    
    public func parseData(_ binary: Data?, error: Error?, linkedObjectsRequestsCallback: JSONLinkedObjectsRequestsCallback?) -> Error? {

        return binary?.parseAsJSON({ json in

            guard let keys = json?.keys, keys.count != 0 else {
                return
            }

            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            keys.forEach { (key) in
                guard let vehiclesJSON = json?[key] as? JSON else { return }
                guard let tag = vehiclesJSON[#keyPath(Vehicles.tag)] as? String else { return }

                let predicate = NSPredicate(format: "%K == %@", #keyPath(Vehicles.tag), tag)
                context.perform {
                    guard let vehicle = NSManagedObject.findOrCreateObject(forClass:Vehicles.self, predicate: predicate, context: context) as? Vehicles else { return }

                    vehicle.mapping(fromJSON: vehiclesJSON, into: context, completion: linkedObjectsRequestsCallback)
                    context.tryToSave()
                }
            }
            
            
            
        })
    }
}
