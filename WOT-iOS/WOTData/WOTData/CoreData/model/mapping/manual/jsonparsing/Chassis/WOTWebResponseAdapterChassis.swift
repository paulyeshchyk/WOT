//
//  WOTWebResponseAdapterChassis.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public class WOTWebResponseAdapterChassis: NSObject, WOTWebResponseAdapter {
    
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
                guard let chassis = data[key] as? [AnyHashable: Any] else { return }
                guard let module_id = chassis[WGJsonFields.module_id] as? String else { return }
                let predicate = NSPredicate(format: "%K == %@", #keyPath(Tankchassis.module_id), module_id)
                guard let newObject = NSManagedObject.findOrCreateObject(forClass:Tankchassis.self, predicate: predicate, context: context) as? Tankchassis else { return }

                newObject.mapping(fromJSON: chassis, into: context, completion: nestedRequestsCallback)
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch { 
                    print("\(#file) \(#function) at \(error.localizedDescription)")
                }
            }
        }
    }
}
