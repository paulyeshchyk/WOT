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

extension Vehicleprofile {
    override public func mapping(json: JSON, objectContext: ObjectContextProtocol, requestPredicate: RequestPredicate, mappingCoordinator: MappingCoordinatorProtocol, requestManager: RequestManagerProtocol) throws {
        // MARK: - Decode properties

        try decode(json: json)

        // MARK: - Link items

        var parentObjectIDList = requestPredicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehicleProfileFetchResult = FetchResult(objectContext: objectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        let ammoListArray = json[#keyPath(Vehicleprofile.ammo)] as? [Any]
        let ammoListMapperClazz = Vehicleprofile.AmmoListLinker.self
        let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)
        mappingCoordinator.linkItems(from: ammoListArray, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, mapperClazz: ammoListMapperClazz, lookupRuleBuilder: ammoLookupBuilder, requestManager: requestManager)

        // MARK: - Armor

        let armorJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON
        let armorListMapperClazz = Vehicleprofile.ArmorListLinker.self
        let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        mappingCoordinator.linkItem(from: armorJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, mapperClazz: armorListMapperClazz, lookupRuleBuilder: armorLookupBuilder, requestManager: requestManager)

        // MARK: - Module

        let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON
        let moduleMapperClazz = Vehicleprofile.ModuleLinker.self
        let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        mappingCoordinator.linkItem(from: moduleJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, mapperClazz: moduleMapperClazz, lookupRuleBuilder: modulesLookupBuilder, requestManager: requestManager)

        // MARK: - Engine

        let engineJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON
        let engineMapperClazz = Vehicleprofile.EngineLinker.self
        let engineLookupBuilder = RootTagRuleBuilder(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
        mappingCoordinator.linkItem(from: engineJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, mapperClazz: engineMapperClazz, lookupRuleBuilder: engineLookupBuilder, requestManager: requestManager)

        // MARK: - Gun

        let gunJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON
        let gunMapperClazz = Vehicleprofile.GunLinker.self
        let gunLookupBuilder = RootTagRuleBuilder(json: gunJSON, linkedClazz: VehicleprofileGun.self)
        mappingCoordinator.linkItem(from: gunJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, mapperClazz: gunMapperClazz, lookupRuleBuilder: gunLookupBuilder, requestManager: requestManager)

        // MARK: - Suspension

        let suspensionJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON
        let suspensionMapperClazz = Vehicleprofile.SuspensionLinker.self
        let suspensionLookupBuilder = RootTagRuleBuilder(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
        mappingCoordinator.linkItem(from: suspensionJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, mapperClazz: suspensionMapperClazz, lookupRuleBuilder: suspensionLookupBuilder, requestManager: requestManager)

        // MARK: - Turret

        let turretJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON
        let turretMapperClazz = Vehicleprofile.TurretLinker.self
        let turretLookupBuilder = RootTagRuleBuilder(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
        mappingCoordinator.linkItem(from: turretJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, mapperClazz: turretMapperClazz, lookupRuleBuilder: turretLookupBuilder, requestManager: requestManager)

        // MARK: - Radio

        let radioJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON
        let radioMapperClazz = Vehicleprofile.RadioLinker.self
        let radioLookupBuilder = RootTagRuleBuilder(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
        mappingCoordinator.linkItem(from: radioJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, mapperClazz: radioMapperClazz, lookupRuleBuilder: radioLookupBuilder, requestManager: requestManager)
    }
}

extension Vehicleprofile {
    public class RadioLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

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

    public class TurretLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let turret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.turret = turret

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class SuspensionLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let suspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.suspension = suspension

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class GunLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType {
            return .external
        }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let gun = fetchResult.managedObject() as? VehicleprofileGun {
                if let vehicleProfile = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? Vehicleprofile {
                    vehicleProfile.gun = gun

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class ModuleLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

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

    public class EngineLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

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

    public class ArmorListLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

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

    public class AmmoListLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

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
