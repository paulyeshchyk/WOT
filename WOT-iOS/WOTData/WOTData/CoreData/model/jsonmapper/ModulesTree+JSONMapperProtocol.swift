//
//  ModulesTree_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension ModulesTree: JSONMapperProtocol {

    public enum FieldKeys: String, CodingKey {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingCompletion?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingCompletion?){
        
        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(ModulesTree.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.module_id)] as? Int ?? 0)
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.is_default)] as? Bool ?? false)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_credit)] as? Int ?? 0)
        self.price_xp = NSDecimalNumber(value: jSON[#keyPath(ModulesTree.price_xp)] as? Int ?? 0)
        
        /**
         *  availableTypes
         *  vehicleRadio, vehicleChassis, vehicleTurret, vehicleEngine, vehicleGun
         */
        self.type = jSON[#keyPath(ModulesTree.type)] as? String
    }
}
