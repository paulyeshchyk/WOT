//
//  VehicleprofileArmorList+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/15/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileArmorList: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return []
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileArmorList.keypaths()
    }
}

extension VehicleprofileArmorList {
    public typealias Fields = Void

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

        coreDataMapping?.requestSubordinate(for: VehicleprofileArmorList.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
