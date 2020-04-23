//
//  Module+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc extension Module: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(Module.name),
                #keyPath(Module.nation),
                #keyPath(Module.tier),
                #keyPath(Module.type),
                #keyPath(Module.price_credit),
                #keyPath(Module.weight),
                #keyPath(Module.tanks),
                #keyPath(Module.image),
                #keyPath(Module.module_id)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return Module.keypaths()
    }
}

extension Module {
    public enum FieldKeys: String, CodingKey {
        case name
        case nation
        case tier
        case module_id
    }

    public typealias Fields = FieldKeys
}

extension Module {
    override public func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(Module.name)] as? String
        self.nation = jSON[#keyPath(Module.nation)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(Module.tier)] as? Int ?? 0)
        self.type = jSON[#keyPath(Module.type)] as? String
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(Module.price_credit)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(Module.weight)] as? Int ?? 0)
        self.module_id = AnyConvertable(jSON[#keyPath(Module.module_id)]).asNSDecimal
        self.image = jSON[#keyPath(Module.image)] as? String

        let idents = [self.module_id?.stringValue].compactMap { $0 }
        if type == "vehicleRadio" {
            #warning("tank_id is expected")
            coreDataMapping?.pullRemoteSubordinate(for: VehicleprofileRadio.self, byIdents: idents, completion: { managedObject in
                if let radio = managedObject as? VehicleprofileRadio {
                    self.vehicleRadio = radio
                    coreDataMapping?.stash(pkCase)
                }
            })
        } else if type == "vehicleEngine" {
            #warning("tank_id is expected")
            coreDataMapping?.pullRemoteSubordinate(for: VehicleprofileEngine.self, byIdents: idents, completion: { managedObject in
                if let engine = managedObject as? VehicleprofileEngine {
                    self.vehicleEngine = engine
                    coreDataMapping?.stash(pkCase)
                }
            })
        } else if type == "vehicleGun" {
            #warning("tank_id is expected")
            coreDataMapping?.pullRemoteSubordinate(for: VehicleprofileGun.self, byIdents: idents, completion: { managedObject in
                if let gun = managedObject as? VehicleprofileGun {
                    self.vehicleGun = gun
                    coreDataMapping?.stash(pkCase)
                }
            })
        } else if type == "vehicleChassis" {
            #warning("tank_id is expected")
            coreDataMapping?.pullRemoteSubordinate(for: VehicleprofileSuspension.self, byIdents: idents, completion: { managedObject in
                if let suspension = managedObject as? VehicleprofileSuspension {
                    self.vehicleChassis = suspension
                    coreDataMapping?.stash(pkCase)
                }
            })
        } else if type == "vehicleTurret" {
            #warning("tank_id is expected")
            coreDataMapping?.pullRemoteSubordinate(for: VehicleprofileTurret.self, byIdents: idents, completion: { managedObject in
                if let turret = managedObject as? VehicleprofileTurret {
                    self.vehicleTurret = turret
                    coreDataMapping?.stash(pkCase)
                }
            })
        }
    }
}

extension Module: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(Module.module_id)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, predicateFormat: "%K == %@")
    }
}
