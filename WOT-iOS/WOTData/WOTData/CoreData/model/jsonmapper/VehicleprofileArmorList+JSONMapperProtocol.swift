//
//  VehicleprofileArmorList+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension VehicleprofileArmorList {
    public enum FieldKeys: String, CodingKey {
        case type
    }

    public typealias Fields = FieldKeys

    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.hull = newObject as? VehicleprofileArmor
            coreDataMapping?.stash(hullCase)
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, forRequest: forRequest, coreDataMapping: coreDataMapping) { newObject in
            self.turret = newObject as? VehicleprofileArmor
            coreDataMapping?.stash(hullCase)
        }
    }
}

extension VehicleprofileArmorList {
    public static func list(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.requestNewSubordinate(VehicleprofileArmorList.self, pkCase) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
