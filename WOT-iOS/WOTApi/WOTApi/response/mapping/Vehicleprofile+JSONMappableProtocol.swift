//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

public enum VehicleProfileMappingError: Error, CustomStringConvertible {
    case noAmmoList(NSDecimalNumber?)
    case noArmor(NSDecimalNumber?)
    case noModule(NSDecimalNumber?)
    case noEngine(NSDecimalNumber?)
    case noGun(NSDecimalNumber?)
    case noSuspension(NSDecimalNumber?)
    case noTurret(NSDecimalNumber?)
    case noRadio(NSDecimalNumber?)
    public var description: String {
        switch self {
        case .noAmmoList(let profile): return "[\(type(of: self))]: No ammo list in profile with id: \(profile ?? -1)"
        case .noArmor(let profile): return "[\(type(of: self))]: No armor in profile with id: \(profile ?? -1)"
        case .noModule(let profile): return "[\(type(of: self))]: No module in profile with id: \(profile ?? -1)"
        case .noEngine(let profile): return "[\(type(of: self))]: No engine in profile with id: \(profile ?? -1)"
        case .noGun(let profile): return "[\(type(of: self))]: No gun in profile with id: \(profile ?? -1)"
        case .noSuspension(let profile): return "[\(type(of: self))]: No suspension in profile with id: \(profile ?? -1)"
        case .noTurret(let profile): return "[\(type(of: self))]: No turret in profile with id: \(profile ?? -1)"
        case .noRadio(let profile): return "[\(type(of: self))]: No radio in profile with id: \(profile ?? -1)"
        }
    }
}

extension Vehicleprofile {
    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {

        guard let profile = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        try decode(decoderContainer: profile)

        // MARK: - Link items

        var parentObjectIDList = map.predicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehicleProfileFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        guard let ammoListArray = profile[#keyPath(Vehicleprofile.ammo)] as? [JSON] else {
            throw VehicleProfileMappingError.noAmmoList(self.tank_id)
        }
        let ammoListMapperClazz = Vehicleprofile.AmmoListLinker.self
        let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)
        
        let ammoListCollection = try JSONCollection(array: ammoListArray)
        inContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, adapterLinker: ammoListMapperClazz, lookupRuleBuilder: ammoLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Armor

        guard let armorJSON = profile[#keyPath(Vehicleprofile.armor)] as? JSON else {
            throw VehicleProfileMappingError.noArmor(self.tank_id)
        }
        
        let armorListMapperClazz = Vehicleprofile.ArmorListLinker.self
        let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let armorCollection = try JSONCollection(element: armorJSON)
        inContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, adapterLinker: armorListMapperClazz, lookupRuleBuilder: armorLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Module

        guard let moduleJSON = profile[#keyPath(Vehicleprofile.modules)] as? JSON else {
            throw VehicleProfileMappingError.noModule(self.tank_id)
        }
        let moduleMapperClazz = Vehicleprofile.ModuleLinker.self
        let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let moduleCollection = try JSONCollection(element: moduleJSON)
        inContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, adapterLinker: moduleMapperClazz, lookupRuleBuilder: modulesLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Engine

        guard let engineJSON = profile[#keyPath(Vehicleprofile.engine)] as? JSON else {
            throw VehicleProfileMappingError.noEngine(self.tank_id)
        }
        let engineMapperClazz = Vehicleprofile.EngineLinker.self
        let engineLookupBuilder = RootTagRuleBuilder(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
        let engineCollection = try JSONCollection(element: engineJSON)
        inContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, adapterLinker: engineMapperClazz, lookupRuleBuilder: engineLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Gun

        guard let gunJSON = profile[#keyPath(Vehicleprofile.gun)] as? JSON else {
            throw VehicleProfileMappingError.noGun(self.tank_id)
        }
        let gunMapperClazz = Vehicleprofile.GunLinker.self
        let gunLookupBuilder = RootTagRuleBuilder(json: gunJSON, linkedClazz: VehicleprofileGun.self)
        let gunCollection = try JSONCollection(element: gunJSON)
        inContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, adapterLinker: gunMapperClazz, lookupRuleBuilder: gunLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Suspension

        guard let suspensionJSON = profile[#keyPath(Vehicleprofile.suspension)] as? JSON else {
            throw VehicleProfileMappingError.noSuspension(self.tank_id)
        }
        let suspensionMapperClazz = Vehicleprofile.SuspensionLinker.self
        let suspensionLookupBuilder = RootTagRuleBuilder(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
        let suspensionCollection = try JSONCollection(element: suspensionJSON)
        inContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, adapterLinker: suspensionMapperClazz, lookupRuleBuilder: suspensionLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Turret

        guard let turretJSON = profile[#keyPath(Vehicleprofile.turret)] as? JSON else {
            throw VehicleProfileMappingError.noTurret(self.tank_id)
        }
        let turretMapperClazz = Vehicleprofile.TurretLinker.self
        let turretLookupBuilder = RootTagRuleBuilder(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
        let turretCollection = try JSONCollection(element: turretJSON)
        inContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, adapterLinker: turretMapperClazz, lookupRuleBuilder: turretLookupBuilder, requestManager: inContext.requestManager)

        // MARK: - Radio

        guard let radioJSON = profile[#keyPath(Vehicleprofile.radio)] as? JSON else {
            throw VehicleProfileMappingError.noRadio(self.tank_id)
        }
        let radioLinker = Vehicleprofile.RadioLinker.self
        let radioLookupBuilder = RootTagRuleBuilder(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
        let radioCollection = try JSONCollection(element: radioJSON)
        inContext.mappingCoordinator?.linkItem(from: radioCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, adapterLinker: radioLinker, lookupRuleBuilder: radioLookupBuilder, requestManager: inContext.requestManager)
    }
}

extension Vehicleprofile {
    public class RadioLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let radio = fetchResult.managedObject() as? VehicleprofileRadio else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileRadio.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            vehicleProfile.radio = radio

            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class TurretLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let turret = fetchResult.managedObject() as? VehicleprofileTurret else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileTurret.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }

            vehicleProfile.turret = turret
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class SuspensionLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let suspension = fetchResult.managedObject() as? VehicleprofileSuspension else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileSuspension.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            vehicleProfile.suspension = suspension

            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class GunLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let gun = fetchResult.managedObject() as? VehicleprofileGun else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileGun.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(Vehicleprofile.self))
                return
            }
            vehicleProfile.gun = gun

            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class ModuleLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let modules = fetchResult.managedObject() as? VehicleprofileModule {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.modules = modules
                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class EngineLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let engine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.engine = engine

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ArmorListLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let armorList = fetchResult.managedObject() as? VehicleprofileArmorList {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.armor = armorList

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class AmmoListLinker: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let ammoList = fetchResult.managedObject() as? VehicleprofileAmmoList {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.ammo = ammoList

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
