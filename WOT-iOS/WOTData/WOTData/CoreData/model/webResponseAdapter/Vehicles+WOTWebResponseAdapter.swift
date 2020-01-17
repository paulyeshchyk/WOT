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
    
    public func parseJSON(_ json: JSON, error err: NSError?, nestedRequestsCallback: JSONMappingCompletion?) {
        if let error = err {
            print("\(#file) \(#function) at \(error.localizedDescription)")
            return
        }
        guard let data = json[WGJsonFields.data] as? [AnyHashable: Any] else {
            return
        }
        
        let keys = data.keys
        guard keys.count != 0 else {
            return
        }

        let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
        context.perform {
            keys.forEach { (key) in
                guard let vehiclesJSON = data[key] as? JSON else { return }
                guard let tag = vehiclesJSON[#keyPath(Vehicles.tag)] as? String else { return }
                let predicate = NSPredicate(format: "%K == %@", #keyPath(Vehicles.tag), tag)
                guard let vehicle = NSManagedObject.findOrCreateObject(forClass:Vehicles.self, predicate: predicate, context: context) as? Vehicles else { return }

                vehicle.mapping(fromJSON: vehiclesJSON, into: context, completion: nestedRequestsCallback)
            }
            print("stores:\(context.persistentStoreCoordinator?.persistentStores)")
            context.tryToSave()
        }
    }
}
