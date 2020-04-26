//
//  VehicleprofileModule+JSONMapperProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 1/16/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot
import CoreData

extension Module {
    @objc
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let parents = pkCase.plainParents.filter({$0 is Vehicles}).compactMap({($0 as? Vehicles)?.tank_id })

        let tank_id = parents.first

        guard let mt = self.type else {
            print("unknown module type")
            return
        }
        let moduleType = VehicleModuleType(rawValue: mt)
        switch moduleType {
        case .vehicleChassis:
            requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, persistentStore: persistentStore, keyPathPrefix: "suspension.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileSuspension {
                    self.suspension = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleGun:
            requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, persistentStore: persistentStore, keyPathPrefix: "gun.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileGun {
                    self.gun = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleRadio:
            requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, persistentStore: persistentStore, keyPathPrefix: "radio.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileRadio {
                    self.radio = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleEngine:
            requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, persistentStore: persistentStore, keyPathPrefix: "engine.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileEngine {
                    self.engine = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleTurret:
            requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, persistentStore: persistentStore, keyPathPrefix: "turret.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileTurret {
                    self.turret = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        default: print(mt)
        }
    }

    private func requestVehicleModule(by id: NSDecimalNumber?, tank_id: NSDecimalNumber?, andClass Clazz: NSManagedObject.Type, persistentStore: WOTPersistentStoreProtocol?, keyPathPrefix: String?, callback: @escaping NSManagedObjectCallback) {
        guard let id = id else {
            return
        }
        guard let tank_id = tank_id else {
            return
        }

        let pkCase = PKCase()
        pkCase[.primary] = Clazz.primaryIdKey(for: id)
        pkCase[.secondary] = Vehicles.primaryKey(for: tank_id)

        persistentStore?.requestSubordinate(for: Clazz, pkCase: pkCase, subordinateRequestType: .remote, keyPathPrefix: keyPathPrefix, onCreateNSManagedObject: callback)
    }
}

extension Module {
    public static func module(fromJSON json: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        persistentStore?.requestSubordinate(for: Module.self, pkCase: pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            persistentStore?.mapping(object: newObject, fromJSON: json, pkCase: pkCase)
            callback(newObject)
        }
    }
}
