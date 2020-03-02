//
//  WOTWebResponseAdapterVehicles.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class VehiclesAdapter: NSObject, WOTWebResponseAdapter {
    
    public func parseJSON(_ json: JSON, nestedRequestsCallback: JSONMappingCompletion?) {

        guard let data = json[WGJsonFields.data] as? [AnyHashable: Any] else {
            print("\(#file) \(#function) at Invalid json")
            return
        }
        
        let keys = data.keys
        guard keys.count != 0 else {
            print("\(#file) \(#function) at Invalid json: no keys")
            return
        }

        let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
        keys.forEach { (key) in
            guard let vehiclesJSON = data[key] as? JSON else { return }
            guard let tag = vehiclesJSON[#keyPath(Vehicles.tag)] as? String else { return }

            let predicate = NSPredicate(format: "%K == %@", #keyPath(Vehicles.tag), tag)
            context.perform {
                guard let vehicle = NSManagedObject.findOrCreateObject(forClass:Vehicles.self, predicate: predicate, context: context) as? Vehicles else { return }

                vehicle.mapping(fromJSON: vehiclesJSON, into: context, completion: nestedRequestsCallback)
                context.tryToSave()
            }
        }

    }
}
