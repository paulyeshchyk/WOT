//
//  VehicleprofileAmmo_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileAmmo: JSONMapperProtocol {
    
    public enum FieldKeys: String, CodingKey {
        case type
    }
    
    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, completion: JSONMappingNestedRequestsCallback?) { }

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, completion: JSONMappingNestedRequestsCallback?) {
        
        defer {
            context.tryToSave()
        }

        self.type = jSON[#keyPath(VehicleprofileAmmo.type)] as? String
        if let penetrationjSON = jSON[#keyPath(VehicleprofileAmmo.penetration)] as? [Any] {
            if let penetrationsObject = VehicleprofileAmmoPenetration.insertNewObject(context) as? VehicleprofileAmmoPenetration {
                penetrationsObject.mapping(fromArray: penetrationjSON, into: context, completion: nil)
                self.penetration = penetrationsObject
            }
        }
        if let damageJSON = jSON[#keyPath(VehicleprofileAmmo.damage)] as? [Any] {
            if let damageObject = VehicleprofileAmmoDamage.insertNewObject(context) as? VehicleprofileAmmoDamage {
                damageObject.mapping(fromArray: damageJSON, into: context, completion: nil)
                self.damage = damageObject
            }
        }
    }
}
