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

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(Module.module_id)
        case .internal: return #keyPath(Module.module_id)// was name
        }
    }
}

// MARK: - Mapping
extension Module {
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)

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
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, context: context, persistentStore: persistentStore, keyPathPrefix: "suspension.", onObjectDidFetch: { context, managedObjectID, _  in
                if let managedObjectID = managedObjectID, let module = context.object(with: managedObjectID) as? VehicleprofileSuspension {
                    self.suspension = module
                    persistentStore?.stash(context: context, hint: pkCase)
                }
                })
        case .vehicleGun:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, context: context, persistentStore: persistentStore, keyPathPrefix: "gun.", onObjectDidFetch: { context, managedObjectID, _ in
                if let managedObjectID = managedObjectID,  let module = context.object(with: managedObjectID) as? VehicleprofileGun {
                    self.gun = module
                    persistentStore?.stash(context: context, hint: pkCase)
                }
                })
        case .vehicleRadio:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, context: context, persistentStore: persistentStore, keyPathPrefix: "radio.", onObjectDidFetch: { context, managedObjectID, _ in
                if let managedObjectID = managedObjectID,  let module = context.object(with: managedObjectID) as? VehicleprofileRadio {
                    self.radio = module
                    persistentStore?.stash(context: context, hint: pkCase)
                }
                })
        case .vehicleEngine:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, context: context, persistentStore: persistentStore, keyPathPrefix: "engine.", onObjectDidFetch: { context, managedObjectID, _ in
                if let managedObjectID = managedObjectID,  let module = context.object(with: managedObjectID) as? VehicleprofileEngine {
                    self.engine = module
                    persistentStore?.stash(context: context, hint: pkCase)
                }
                })
        case .vehicleTurret:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, context: context, persistentStore: persistentStore, keyPathPrefix: "turret.", onObjectDidFetch: { context, managedObjectID, _ in
                if let managedObjectID = managedObjectID,  let module = context.object(with: managedObjectID) as? VehicleprofileTurret {
                    self.turret = module
                    persistentStore?.stash(context: context, hint: pkCase)
                }
                })
        default: print(mt)
        }
    }

    private func requestVehicleModule(by module_id: NSDecimalNumber, tank_id: NSDecimalNumber, andClass modelClazz: NSManagedObject.Type, context: NSManagedObjectContext, persistentStore: WOTPersistentStoreProtocol?, keyPathPrefix: String?, onObjectDidFetch: @escaping NSManagedObjectErrorCompletion) {
        let pkCase = PKCase()
        pkCase[.primary] = modelClazz.primaryKey(for: module_id, andType: .external)
        pkCase[.secondary] = Vehicles.primaryKey(for: tank_id, andType: .internal)

        persistentStore?.fetchRemote(context: context, byModelClass: modelClazz, pkCase: pkCase, keypathPrefix: keyPathPrefix, onObjectDidFetch: onObjectDidFetch)
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
