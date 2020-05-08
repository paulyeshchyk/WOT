//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension Vehicleprofile {
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        // MARK: - Decode properties

        try decode(json: json)

        // MARK: - Link items

        var parentObjectIDList = pkCase.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehicleProfileFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - AmmoList

        let ammoListArray = json[#keyPath(Vehicleprofile.ammo)] as? [Any]
        let ammoListMapperClazz = Vehicleprofile.VehicleprofileAmmoListLinker.self
        let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)
        mappingCoordinator?.linkItems(from: ammoListArray, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, mapperClazz: ammoListMapperClazz, linkLookupRuleBuilder: ammoLookupBuilder)

        // MARK: - Armor

        let armorJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON
        let armorListMapperClazz = Vehicleprofile.VehicleprofileArmorListLinker.self
        let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        mappingCoordinator?.linkItem(from: armorJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, mapperClazz: armorListMapperClazz, linkLookupRuleBuilder: armorLookupBuilder)

        // MARK: - Module

        let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON
        let moduleMapperClazz = Vehicleprofile.VehicleprofileModuleLinker.self
        let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        mappingCoordinator?.linkItem(from: moduleJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, mapperClazz: moduleMapperClazz, linkLookupRuleBuilder: modulesLookupBuilder)

        // MARK: - Engine

        let engineJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON
        let engineMapperClazz = Vehicleprofile.VehicleprofileEngineLinker.self
        let engineLookupBuilder = RootTagRuleBuilder(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
        mappingCoordinator?.linkItem(from: engineJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, mapperClazz: engineMapperClazz, linkLookupRuleBuilder: engineLookupBuilder)

        // MARK: - Gun

        let gunJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON
        let gunMapperClazz = Vehicleprofile.VehicleprofileGunLinker.self
        let gunLookupBuilder = RootTagRuleBuilder(json: gunJSON, linkedClazz: VehicleprofileGun.self)
        mappingCoordinator?.linkItem(from: gunJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, mapperClazz: gunMapperClazz, linkLookupRuleBuilder: gunLookupBuilder)

        // MARK: - Suspension

        let suspensionJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON
        let suspensionMapperClazz = Vehicleprofile.VehicleprofileSuspensionLinker.self
        let suspensionLookupBuilder = RootTagRuleBuilder(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
        mappingCoordinator?.linkItem(from: suspensionJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, mapperClazz: suspensionMapperClazz, linkLookupRuleBuilder: suspensionLookupBuilder)

        // MARK: - Turret

        let turretJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON
        let turretMapperClazz = Vehicleprofile.VehicleprofileTurretLinker.self
        let turretLookupBuilder = RootTagRuleBuilder(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
        mappingCoordinator?.linkItem(from: turretJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, mapperClazz: turretMapperClazz, linkLookupRuleBuilder: turretLookupBuilder)

        // MARK: - Radio

        let radioJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON
        let radioMapperClazz = Vehicleprofile.VehicleprofileRadioLinker.self
        let radioLookupBuilder = RootTagRuleBuilder(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
        mappingCoordinator?.linkItem(from: radioJSON, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, mapperClazz: radioMapperClazz, linkLookupRuleBuilder: radioLookupBuilder)
    }
}

extension Vehicleprofile {
    public class VehicleprofileRadioLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let radio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.radio = radio

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileTurretLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let turret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.turret = turret

                    self.coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileSuspensionLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let suspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.suspension = suspension

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileGunLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType {
            return .remote
        }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let gun = fetchResult.managedObject() as? VehicleprofileGun {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.gun = gun

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileModuleLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let modules = fetchResult.managedObject() as? VehicleprofileModule {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.modules = modules
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileEngineLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let engine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.engine = engine

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileArmorListLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let armorList = fetchResult.managedObject() as? VehicleprofileArmorList {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.armor = armorList

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileAmmoListLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let ammoList = fetchResult.managedObject() as? VehicleprofileAmmoList {
                if let vehicleProfile = masterFetchResult?.managedObject(inContext: context) as? Vehicleprofile {
                    vehicleProfile.ammo = ammoList

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
