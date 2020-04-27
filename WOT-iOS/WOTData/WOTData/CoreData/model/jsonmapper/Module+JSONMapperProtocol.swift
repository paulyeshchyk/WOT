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
    public override func mapping(fromJSON jSON: JSON, pkCase: RemotePKCase, persistentStore: WOTPersistentStoreProtocol?) {
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
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, persistentStore: persistentStore, keyPathPrefix: "suspension.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileSuspension {
                    self.suspension = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleGun:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, persistentStore: persistentStore, keyPathPrefix: "gun.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileGun {
                    self.gun = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleRadio:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, persistentStore: persistentStore, keyPathPrefix: "radio.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileRadio {
                    self.radio = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleEngine:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, persistentStore: persistentStore, keyPathPrefix: "engine.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileEngine {
                    self.engine = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        case .vehicleTurret:
            requestVehicleModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, persistentStore: persistentStore, keyPathPrefix: "turret.", callback: { managedObject in
                if let module = managedObject as? VehicleprofileTurret {
                    self.turret = module
                    persistentStore?.stash(hint: pkCase)
                }
                })
        default: print(mt)
        }
    }

    private func requestVehicleModule(by module_id: NSDecimalNumber, tank_id: NSDecimalNumber, andClass Clazz: NSManagedObject.Type, persistentStore: WOTPersistentStoreProtocol?, keyPathPrefix: String?, callback: @escaping NSManagedObjectCallback) {
        let pkCase = RemotePKCase()
        pkCase[.primary] = Clazz.primaryIdKey(for: module_id)
        pkCase[.secondary] = Vehicles.primaryKey(for: tank_id)

        persistentStore?.remoteSubordinate(for: Clazz, pkCase: pkCase, keypathPrefix: keyPathPrefix, onCreateNSManagedObject: callback)
    }
}
