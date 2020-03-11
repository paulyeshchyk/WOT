//
//  VehicleprofileSuspension_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileSuspension: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case name
        case weight
        case load_limit
        case tag
        case tier
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingNestedRequestsCallback?){ }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingNestedRequestsCallback?){

        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(VehicleprofileSuspension.name)] as? String
        self.tag = jSON[#keyPath(VehicleprofileSuspension.tag)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.tier)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.weight)] as? Int ?? 0)
        self.load_limit = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileSuspension.load_limit)] as? Int ?? 0)

    }
}
