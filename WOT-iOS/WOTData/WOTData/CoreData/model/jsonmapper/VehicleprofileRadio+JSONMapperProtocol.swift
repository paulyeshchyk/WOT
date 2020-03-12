//
//  VehicleprofileRadio_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileRadio: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case tier
        case signal_range
        case tag
        case weight
        case name
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(fromArray jSON: [Any], into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?){

        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(VehicleprofileRadio.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileRadio.tag)] as? String
        self.signal_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.signal_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileRadio.weight)] as? Int ?? 0)
    }
}

