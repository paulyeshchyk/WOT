//
//  VehicleprofileAmmoList_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmoList: JSONMapperProtocol {
    
    public typealias Fields = Void
    
    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?) {

        defer {
            context.tryToSave()
        }

        array.compactMap { $0 as? JSON }.forEach { (jSON) in
            if let ammoObject = VehicleprofileAmmo.insertNewObject(context) as? VehicleprofileAmmo {
                ammoObject.mapping(fromJSON: jSON, into: context, completion: nil)
                self.addToVehicleprofileAmmo(ammoObject)
            }
        }
    }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?) { }
}
