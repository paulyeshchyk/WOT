//
//  VehicleprofileArmorList+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension VehicleprofileArmorList: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case type
    }
    
    public typealias Fields = FieldKeys
    
    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?){

        defer {
            context.tryToSave()
        }

        if let hullJSON = jSON[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
            if let hullObject = VehicleprofileArmor.insertNewObject(context) as? VehicleprofileArmor {
                hullObject.mapping(fromJSON: hullJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.hull = hullObject
            }
        }

        if let turretJSON = jSON[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
            if let turretObject = VehicleprofileArmor.insertNewObject(context) as? VehicleprofileArmor {
                turretObject.mapping(fromJSON: turretJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.turret = turretObject
            }
        }
    }
}
