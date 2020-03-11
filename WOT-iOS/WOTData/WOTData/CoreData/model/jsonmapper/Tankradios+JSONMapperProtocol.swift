//
//  Tankradios_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Tankradios: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case name
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingNestedRequestsCallback?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingNestedRequestsCallback?){
        
        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(Tankradios.name)] as? String
        self.level = NSDecimalNumber(value: jSON[#keyPath(Tankradios.level)] as? Int ?? 0)
        self.nation = jSON[#keyPath(Tankradios.nation)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankradios.module_id)] as? Int ?? 0)
        self.distance = NSDecimalNumber(value: jSON[#keyPath(Tankradios.distance)] as? Int ?? 0)
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Tankradios.price_credit)] as? Int ?? 0)
        self.price_gold = NSDecimalNumber(value: jSON[#keyPath(Tankradios.price_gold)] as? Int ?? 0)
    }
}
