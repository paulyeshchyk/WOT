//
//  VehicleprofileTurret_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//


extension VehicleprofileTurret: JSONMapperProtocol {
    
    public typealias Fields = Void

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){ }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){

        defer {
            context.tryToSave()
        }

        self.name = jSON[#keyPath(VehicleprofileTurret.name)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.tier)] as? Int ?? 0)
        self.tag = jSON[#keyPath(VehicleprofileTurret.tag)] as? String
        self.view_range = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.view_range)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.weight)] as? Int ?? 0)
        self.traverse_left_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_left_arc)] as? Int ?? 0)
        self.traverse_right_arc = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.traverse_right_arc)] as? Int ?? 0)
        self.hp = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileTurret.hp)] as? Int ?? 0)
    }
}
