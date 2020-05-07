//
//  Module+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension Module {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)

        let parents = pkCase.plainParents.filter({$0 is Vehicles}).compactMap({ $0.tank_id as? NSDecimalNumber })

        guard let module_id = self.module_id else {
            print("module_id not found")
            return
        }

        guard let moduleTypeString = self.type else {
            print("unknown module type")
            return
        }
        let moduleType = VehicleModuleType(rawValue: moduleTypeString)

        let tank_id = parents.first

        switch moduleType {
        case .vehicleChassis:
            let vehicleSuspensionLinker = Module.ModuleSuspensionLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileSuspension.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "suspension.", linker: vehicleSuspensionLinker)
        case .vehicleGun:
            let vehicleGunLinker = Module.ModuleGunLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileGun.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "gun.", linker: vehicleGunLinker)
        case .vehicleRadio:
            let vehicleRadioLinker = Module.ModuleRadioLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileRadio.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "radio.", linker: vehicleRadioLinker)
        case .vehicleEngine:
            let vehicleEngineLinker = Module.ModuleEngineLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileEngine.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "engine.", linker: vehicleEngineLinker)
        case .vehicleTurret:
            let vehicleTurretLinker = Module.ModuleTurretLinker(objectID: self.objectID, identifier: module_id, coreDataStore: mappingCoordinator?.coreDataStore)
            fetchRemoteModule(by: module_id, tank_id: tank_id, andClass: VehicleprofileTurret.self, context: context, mappingCoordinator: mappingCoordinator, keyPathPrefix: "turret.", linker: vehicleTurretLinker)
        case .none, .tank, .unknown:
            fatalError("unknown module type")
        }
    }

    private func fetchRemoteModule(by module_id: NSDecimalNumber, tank_id: NSDecimalNumber?, andClass modelClazz: NSManagedObject.Type, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?, keyPathPrefix: String?, linker: JSONAdapterLinkerProtocol) {
        let pkCase = PKCase()
        pkCase[.primary] = modelClazz.primaryKey(for: module_id, andType: .external)
        if let tank_id = tank_id {
            pkCase[.secondary] = Vehicles.primaryKey(for: tank_id, andType: .internal)
        }

        mappingCoordinator?.fetchRemote(context: context, byModelClass: modelClazz, pkCase: pkCase, keypathPrefix: keyPathPrefix, linker: linker)
    }
}

extension Module {
    public class ModuleEngineLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["engine"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileEngine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let module = fetchResult.context.object(with: self.objectID) as? Module {
                    vehicleProfileEngine.engine_id = self.identifier as? NSDecimalNumber
                    module.engine = vehicleProfileEngine
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleTurretLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["turret"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileTurret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let module = context.object(with: self.objectID) as? Module {
                    vehicleProfileTurret.turret_id = self.identifier as? NSDecimalNumber
                    module.turret = vehicleProfileTurret
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleSuspensionLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["suspension"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileSuspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let module = context.object(with: self.objectID) as? Module {
                    vehicleProfileSuspension.suspension_id = self.identifier as? NSDecimalNumber
                    module.suspension = vehicleProfileSuspension
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleRadioLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["radio"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileRadio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let module = context.object(with: self.objectID) as? Module {
                    vehicleProfileRadio.radio_id = self.identifier as? NSDecimalNumber
                    module.radio = vehicleProfileRadio
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleGunLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .internal }

        override public func onJSONExtraction(json: JSON) -> JSON {
            guard let result = json["gun"] as? JSON else {
                fatalError("invalid json")
            }
            return result
        }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let vehicleProfileGun = fetchResult.managedObject() as? VehicleprofileGun {
                if let module = context.object(with: self.objectID) as? Module {
                    vehicleProfileGun.gun_id = self.identifier as? NSDecimalNumber
                    module.gun = vehicleProfileGun
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
