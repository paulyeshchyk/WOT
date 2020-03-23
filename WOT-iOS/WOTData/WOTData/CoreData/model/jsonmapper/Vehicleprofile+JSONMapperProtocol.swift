//
//  Vehicleprofile_FillProperties.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/22/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

extension Vehicleprofile: JSONMapperProtocol {
    public enum FieldKeys: String, CodingKey {
        case max_ammo
        case weight
        case hp
        case is_default
        case hull_weight
        case speed_forward
        case hull_hp
        case speed_backward
        case tank_id
        case max_weight
    }

    public typealias Fields = FieldKeys

    @objc
    public func mapping(fromArray array: [Any], into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {}

    @objc
    public func mapping(fromJSON jSON: JSON, into context: NSManagedObjectContext, jsonLinksCallback: WOTJSONLinksCallback?) {
        defer {
            context.tryToSave()
        }

        self.tank_id = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.tank_id)] as? Int ?? 0)
        self.is_default = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.is_default)] as? Int ?? 0)
        self.max_ammo = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.max_ammo)] as? Int ?? 0)
        self.max_weight = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.max_weight)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.weight)] as? Int ?? 0)
        self.hp = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.hp)] as? Int ?? 0)
        self.hull_hp = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.hull_hp)] as? Int ?? 0)
        self.hull_weight = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.hull_weight)] as? Int ?? 0)
        self.speed_backward = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.speed_backward)] as? Int ?? 0)
        self.speed_forward = NSDecimalNumber(value: jSON[#keyPath(Vehicleprofile.speed_forward)] as? Int ?? 0)

        if let ammoJSON = jSON[#keyPath(Vehicleprofile.ammo)]  as? [Any] {
            if let ammoObject = VehicleprofileAmmoList.insertNewObject(context) as? VehicleprofileAmmoList {
                ammoObject.mapping(fromArray: ammoJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.ammo = ammoObject
            }
        }

        if let armorJSON = jSON[#keyPath(Vehicleprofile.armor)]  as? JSON {
            if let armorObject = VehicleprofileArmorList.insertNewObject(context) as? VehicleprofileArmorList {
                armorObject.mapping(fromJSON: armorJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.armor = armorObject
            }
        }

        if let engineJSON = jSON[#keyPath(Vehicleprofile.engine)]  as? JSON {
            if let engineObject = VehicleprofileEngine.insertNewObject(context) as? VehicleprofileEngine {
                engineObject.mapping(fromJSON: engineJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.engine = engineObject
            }
        }

        if let gunJSON = jSON[#keyPath(Vehicleprofile.gun)]  as? JSON {
            if let gunObject = VehicleprofileGun.insertNewObject(context) as? VehicleprofileGun {
                gunObject.mapping(fromJSON: gunJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.gun = gunObject
            }
        }

        if let radioJSON = jSON[#keyPath(Vehicleprofile.radio)]  as? JSON {
            if let radioObject = VehicleprofileRadio.insertNewObject(context) as? VehicleprofileRadio {
                radioObject.mapping(fromJSON: radioJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.radio = radioObject
            }
        }

        if let suspensionJSON = jSON[#keyPath(Vehicleprofile.suspension)]  as? JSON {
            if let suspensionObject = VehicleprofileSuspension.insertNewObject(context) as? VehicleprofileSuspension {
                suspensionObject.mapping(fromJSON: suspensionJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.suspension = suspensionObject
            }
        }

        if let turretJSON = jSON[#keyPath(Vehicleprofile.turret)]  as? JSON {
            if let turretObject = VehicleprofileTurret.insertNewObject(context) as? VehicleprofileTurret {
                turretObject.mapping(fromJSON: turretJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.turret = turretObject
            }
        }

        if let modulesJSON = jSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            if let modulesObject = VehicleprofileModule.insertNewObject(context) as? VehicleprofileModule {
                modulesObject.mapping(fromJSON: modulesJSON, into: context, jsonLinksCallback: jsonLinksCallback)
                self.modules = modulesObject
            }
        }
    }
}
