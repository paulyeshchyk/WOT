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
        let ammoListMapperClazz = Vehicleprofile.VehicleprofileAmmoListManagedObjectCreator.self
        let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)

        let ammoListCollection = try JSONCollection(array: ammoListArray)
        inContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, managedObjectCreatorClass: ammoListMapperClazz, lookupRuleBuilder: ammoLookupBuilder, appContext: inContext)

        // MARK: - Armor

        guard let armorJSON = profile[#keyPath(Vehicleprofile.armor)] as? JSON else {
            throw VehicleProfileMappingError.noArmor(self.tank_id)
        }

        let armorListMapperClazz = Vehicleprofile.VehicleprofileArmorListManagedObjectCreator.self
        let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let armorCollection = try JSONCollection(element: armorJSON)
        inContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, managedObjectCreatorClass: armorListMapperClazz, lookupRuleBuilder: armorLookupBuilder, appContext: inContext)

        // MARK: - Module

        guard let moduleJSON = profile[#keyPath(Vehicleprofile.modules)] as? JSON else {
            throw VehicleProfileMappingError.noModule(self.tank_id)
        }
        let moduleMapperClazz = Vehicleprofile.VehicleprofileModuleManagedObjectCreator.self
        let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let moduleCollection = try JSONCollection(element: moduleJSON)
        inContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, managedObjectCreatorClass: moduleMapperClazz, lookupRuleBuilder: modulesLookupBuilder, appContext: inContext)

        // MARK: - Engine

        guard let engineJSON = profile[#keyPath(Vehicleprofile.engine)] as? JSON else {
            throw VehicleProfileMappingError.noEngine(self.tank_id)
        }
        let engineMapperClazz = Vehicleprofile.VehicleprofileEngineManagedObjectCreator.self
        let engineLookupBuilder = RootTagRuleBuilder(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
        let engineCollection = try JSONCollection(element: engineJSON)
        inContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, managedObjectCreatorClass: engineMapperClazz, lookupRuleBuilder: engineLookupBuilder, appContext: inContext)

        // MARK: - Gun

        guard let gunJSON = profile[#keyPath(Vehicleprofile.gun)] as? JSON else {
            throw VehicleProfileMappingError.noGun(self.tank_id)
        }
        let gunMapperClazz = Vehicleprofile.VehicleprofileGunManagedObjectCreator.self
        let gunLookupBuilder = RootTagRuleBuilder(json: gunJSON, linkedClazz: VehicleprofileGun.self)
        let gunCollection = try JSONCollection(element: gunJSON)
        inContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, managedObjectCreatorClass: gunMapperClazz, lookupRuleBuilder: gunLookupBuilder, appContext: inContext)

        // MARK: - Suspension

        guard let suspensionJSON = profile[#keyPath(Vehicleprofile.suspension)] as? JSON else {
            throw VehicleProfileMappingError.noSuspension(self.tank_id)
        }
        let suspensionMapperClazz = Vehicleprofile.VehicleprofileSuspensionManagedObjectCreator.self
        let suspensionLookupBuilder = RootTagRuleBuilder(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
        let suspensionCollection = try JSONCollection(element: suspensionJSON)
        inContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, managedObjectCreatorClass: suspensionMapperClazz, lookupRuleBuilder: suspensionLookupBuilder, appContext: inContext)

        // MARK: - Turret

        guard let turretJSON = profile[#keyPath(Vehicleprofile.turret)] as? JSON else {
            throw VehicleProfileMappingError.noTurret(self.tank_id)
        }
        let turretMapperClazz = Vehicleprofile.VehicleprofileTurretManagedObjectCreator.self
        let turretLookupBuilder = RootTagRuleBuilder(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
        let turretCollection = try JSONCollection(element: turretJSON)
        inContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, managedObjectCreatorClass: turretMapperClazz, lookupRuleBuilder: turretLookupBuilder, appContext: inContext)

        // MARK: - Radio

        guard let radioJSON = profile[#keyPath(Vehicleprofile.radio)] as? JSON else {
            throw VehicleProfileMappingError.noRadio(self.tank_id)
        }
        let radioLinker = Vehicleprofile.VehicleprofileRadioManagedObjectCreator.self
        let radioLookupBuilder = RootTagRuleBuilder(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
        let radioCollection = try JSONCollection(element: radioJSON)
        inContext.mappingCoordinator?.linkItem(from: radioCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, managedObjectCreatorClass: radioLinker, lookupRuleBuilder: radioLookupBuilder, appContext: inContext)
    }
}

extension Vehicleprofile {
    public class VehicleprofileRadioManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
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

    public class VehicleprofileTurretManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
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

    public class VehicleprofileSuspensionManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
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

    public class VehicleprofileGunManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
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

    public class VehicleprofileModuleManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            guard let modules = fetchResult.managedObject() as? VehicleprofileModule else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileModule.self))
                return
            }
            vehicleProfile.modules = modules
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class VehicleprofileEngineManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            guard let engine = fetchResult.managedObject() as? VehicleprofileEngine else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileEngine.self))
                return
            }
            vehicleProfile.engine = engine

            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class VehicleprofileArmorListManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            guard let armorList = fetchResult.managedObject() as? VehicleprofileArmorList else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
                return
            }
            vehicleProfile.armor = armorList

            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class VehicleprofileAmmoListManagedObjectCreator: ManagedObjectCreator {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        override public func onJSONExtraction(json: JSON) -> JSON? {
            return json
        }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.managedObjectContext
            guard let ammoList = fetchResult.managedObject() as? VehicleprofileAmmoList else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
                return
            }
            guard let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
                return
            }
            vehicleProfile.ammo = ammoList

            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }
}
