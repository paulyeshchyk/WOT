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
    public override func mapping(fromJSON jSON: JSON, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?) {
        do {
            try self.decode(json: jSON)
        } catch let error {
            print("JSON Mapping Error: \(error)")
        }

        let parents = pkCase.plainParents.filter({$0 is Vehicles}).compactMap({($0 as? Vehicles)?.tank_id })

        let tank_id = parents.first

        if let moduleType = self.type {
            if let moduleType = VehicleModuleType(rawValue: moduleType) {
                switch moduleType {
                case .vehicleChassis:
                    requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, coreDataMapping: coreDataMapping, keyPathPrefix: "suspension.", callback: { managedObject in
                        if let module = managedObject as? VehicleprofileSuspension {
                            self.suspension = module
                            coreDataMapping?.stash(hint: pkCase)
                        }
                    })
                case .vehicleGun:
                    requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, coreDataMapping: coreDataMapping, keyPathPrefix: "gun.", callback: { managedObject in
                        if let module = managedObject as? VehicleprofileGun {
                            self.gun = module
                            coreDataMapping?.stash(hint: pkCase)
                        }
                    })
                case .vehicleRadio:
                    requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, coreDataMapping: coreDataMapping, keyPathPrefix: "radio.", callback: { managedObject in
                        if let module = managedObject as? VehicleprofileRadio {
                            self.radio = module
                            coreDataMapping?.stash(hint: pkCase)
                        }
                    })
                case .vehicleEngine:
                    requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, coreDataMapping: coreDataMapping, keyPathPrefix: "engine.", callback: { managedObject in
                        if let module = managedObject as? VehicleprofileEngine {
                            self.engine = module
                            coreDataMapping?.stash(hint: pkCase)
                        }
                    })
                case .vehicleTurret:
                    requestVehicleModule(by: self.module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, coreDataMapping: coreDataMapping, keyPathPrefix: "turret.", callback: { managedObject in
                        if let module = managedObject as? VehicleprofileTurret {
                            self.turret = module
                            coreDataMapping?.stash(hint: pkCase)
                        }
                    })
                case .unknown:print(moduleType.rawValue)
                case .tank:print(moduleType.rawValue)
                }
            }
        }
    }

    private func requestVehicleModule(by id: NSDecimalNumber?, tank_id: NSDecimalNumber?, andClass Clazz: NSManagedObject.Type, coreDataMapping: CoreDataMappingProtocol?, keyPathPrefix: String?, callback: @escaping NSManagedObjectCallback) {
        guard let id = id else {
            return
        }
        guard let tank_id = tank_id else {
            return
        }

        let pkCase = PKCase()
        pkCase[.primary] = Clazz.primaryIdKey(for: id)
        pkCase[.secondary] = Vehicles.primaryKey(for: tank_id)

        coreDataMapping?.requestSubordinate(for: Clazz, pkCase, subordinateRequestType: .remote, keyPathPrefix: keyPathPrefix, callback: callback)
    }
}

extension Module {
    public static func module(fromJSON json: Any?, pkCase: PKCase, forRequest: WOTRequestProtocol, coreDataMapping: CoreDataMappingProtocol?, callback: @escaping NSManagedObjectCallback) {
        guard let json = json as? JSON else { return }

        coreDataMapping?.requestSubordinate(for: Module.self, pkCase, subordinateRequestType: .local, keyPathPrefix: nil) { newObject in
            coreDataMapping?.mapping(object: newObject, fromJSON: json, pkCase: pkCase, forRequest: forRequest)
            callback(newObject)
        }
    }
}
