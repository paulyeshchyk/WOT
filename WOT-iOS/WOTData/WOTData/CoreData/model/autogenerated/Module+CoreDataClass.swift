//
//  Module+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Module)
public class Module: NSManagedObject {}

// MARK: - Coding Keys
extension Module {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case name
        case nation
        case tier
        case type
        case price_credit
        case weight
        case image
        case module_id
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case tanks
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath() -> String {
        return #keyPath(Module.name)
    }

    override public class func primaryIdKeyPath() -> String {
        return #keyPath(Module.module_id)
    }
}

// MARK: - Mapping
extension Module {
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let parents = pkCase.plainParents.filter({$0 is Vehicles}).compactMap({ $0.tank_id as? NSDecimalNumber })

        guard let tank_id = parents.first else {
            print("tankID not found")
            return
        }

        guard let module_id = self.module_id else {
            print("module_id not found")
            return
        }

        guard let mt = self.type else {
            print("unknown module type")
            return
        }
        let moduleType = VehicleModuleType(rawValue: mt)
        switch moduleType {
        case .vehicleChassis:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, persistentStore: persistentStore, keyPathPrefix: "suspension.", onCompleteObjectCreationL9: { managedObject, _ in
                if let module = managedObject as? VehicleprofileSuspension {
                    self.suspension = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleGun:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, persistentStore: persistentStore, keyPathPrefix: "gun.", onCompleteObjectCreationL9: { managedObject, _ in
                if let module = managedObject as? VehicleprofileGun {
                    self.gun = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleRadio:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, persistentStore: persistentStore, keyPathPrefix: "radio.", onCompleteObjectCreationL9: { managedObject, _ in
                if let module = managedObject as? VehicleprofileRadio {
                    self.radio = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleEngine:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, persistentStore: persistentStore, keyPathPrefix: "engine.", onCompleteObjectCreationL9: { managedObject, _ in
                if let module = managedObject as? VehicleprofileEngine {
                    self.engine = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleTurret:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, persistentStore: persistentStore, keyPathPrefix: "turret.", onCompleteObjectCreationL9: { managedObject, _ in
                if let module = managedObject as? VehicleprofileTurret {
                    self.turret = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        default: print(mt)
        }
    }

    private func requestVehicleModule(by module_id: NSDecimalNumber, tank_id: NSDecimalNumber, andClass Clazz: NSManagedObject.Type, persistentStore: WOTPersistentStoreProtocol?, keyPathPrefix: String?, onCompleteObjectCreationL9: @escaping NSManagedObjectErrorCompletion) {
        let pkCase = PKCase()
        pkCase[.primary] = Clazz.primaryIdKey(for: module_id)
        pkCase[.secondary] = Vehicles.primaryKey(for: tank_id)

        persistentStore?.remoteSubordinate(for: Clazz, pkCase: pkCase, keypathPrefix: keyPathPrefix, onCompleteObjectCreationL8: onCompleteObjectCreationL9)
    }
}

// MARK: - JSONDecoding
extension Module: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.module_id = try container.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.nation = try container.decodeIfPresent(String.self, forKey: .nation)
        self.tier = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.price_credit = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.weight = try container.decodeIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}
