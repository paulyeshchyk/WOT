//
//  Tankchassis_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Tankchassis: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case name
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?){ }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONLinkedObjectsRequestsCallback?){
        
        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(Tankchassis.name)] as? String
        self.module_id = NSDecimalNumber(value: jSON[#keyPath(Tankchassis.module_id)] as? Int ?? 0)
        self.level = jSON[#keyPath(Tankchassis.level)] as? NSDecimalNumber
        self.nation = jSON[#keyPath(Tankchassis.nation)] as? String
        self.max_load = jSON[#keyPath(Tankchassis.max_load)] as? NSNumber
        self.price_credit = jSON[#keyPath(Tankchassis.price_credit)] as? NSDecimalNumber
        self.price_gold = jSON[#keyPath(Tankchassis.price_gold)] as? NSDecimalNumber
        self.rotation_speed = jSON[#keyPath(Tankchassis.rotation_speed)] as? NSDecimalNumber
    }

}
