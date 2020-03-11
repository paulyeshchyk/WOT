//
//  WOTWebResponseAdapterChassis.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTWebResponseAdapterChassis: NSObject, WOTWebResponseAdapter {
    
    public func parseData(_ binary: Data?, error: Error?, nestedRequestsCallback: JSONMappingNestedRequestsCallback?) -> Error? {
        
        return binary?.parseAsJSON { (json) in

            guard let keys = json?.keys, keys.count != 0 else {
                return
            }
            
            let context = WOTTankCoreDataProvider.sharedInstance.workManagedObjectContext
            context.perform {
                keys.forEach { (key) in
                    guard let chassis = json?[key] as? [AnyHashable: Any] else { return }
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
}
