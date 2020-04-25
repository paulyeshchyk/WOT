//
//  VehicleProfileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

extension VehicleprofileModule: KeypathProtocol {
    @objc
    public class func keypaths() -> [String] {
        return [#keyPath(VehicleprofileModule.name),
                #keyPath(VehicleprofileModule.nation),
                #keyPath(VehicleprofileModule.tier),
                #keyPath(VehicleprofileModule.type),
                #keyPath(VehicleprofileModule.price_credit),
                #keyPath(VehicleprofileModule.weight),
                #keyPath(VehicleprofileModule.tanks),
                #keyPath(VehicleprofileModule.image),
                #keyPath(VehicleprofileModule.module_id)]
    }

    @objc
    public func instanceKeypaths() -> [String] {
        return VehicleprofileModule.keypaths()
    }
}

extension VehicleprofileModule {
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey {
        case name
        case nation
        case tier
        case module_id
    }

    override public func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        self.name = jSON[#keyPath(VehicleprofileModule.name)] as? String
        self.nation = jSON[#keyPath(VehicleprofileModule.nation)] as? String
        self.tier = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.tier)] as? Int ?? 0)
        self.type = jSON[#keyPath(VehicleprofileModule.type)] as? String
        self.price_credit = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.price_credit)] as? Int ?? 0)
        self.weight = NSDecimalNumber(value: jSON[#keyPath(VehicleprofileModule.weight)] as? Int ?? 0)
        self.module_id = AnyConvertable(jSON[#keyPath(VehicleprofileModule.module_id)]).asNSDecimal
        self.image = jSON[#keyPath(VehicleprofileModule.image)] as? String

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

extension VehicleprofileModule: PrimaryKeypathProtocol {
    private static let pkey: String = #keyPath(VehicleprofileModule.module_id)

    public static func primaryKeyPath() -> String? {
        return self.pkey
    }

    public static func predicate(for ident: AnyObject?) -> NSPredicate? {
        guard let ident = ident as? String else { return nil }
        return NSPredicate(format: "%K == %@", self.pkey, ident)
    }

    public static func primaryKey(for ident: AnyObject?) -> WOTPrimaryKey? {
        guard let ident = ident else { return nil }
        return WOTPrimaryKey(name: self.pkey, value: ident as AnyObject, nameAlias: self.pkey, predicateFormat: "%K == %@")
    }
}

extension VehicleprofileModule {
    public static func module(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.requestSubordinate(for: VehicleprofileModule.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
