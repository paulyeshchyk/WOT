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

        // MARK: - Ammo

        let ammoListArray = json[#keyPath(Vehicleprofile.ammo)] as? [Any]
        let ammoListLinkerType = Vehicleprofile.VehicleprofileAmmoListLinker.self
        let ammoLookupBuilder = LinkLookupRuleBuilderParentID(pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parents: parentObjectIDList)
        mappingCoordinator?.linkItems(from: ammoListArray, clazz: VehicleprofileAmmoList.self, linkerType: ammoListLinkerType, linkLookupRuleBuilder: ammoLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Armor

        let armorJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON
        let armorListLinkerType = Vehicleprofile.VehicleprofileArmorListLinker.self
        let armorLookupBuilder = LinkLookupRuleBuilderParentIDAndObjectID(json: armorJSON, pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList, primaryKeyType: .none, clazz: VehicleprofileModule.self)
        mappingCoordinator?.linkItem(from: armorJSON, clazz: VehicleprofileArmorList.self, linkerType: armorListLinkerType, linkLookupRuleBuilder: armorLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Modules

        let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON
        let moduleLinkerType = Vehicleprofile.VehicleprofileModuleLinker.self
        let modulesLookupBuilder = LinkLookupRuleBuilderParentIDAndObjectID(json: moduleJSON, pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList, primaryKeyType: .none, clazz: VehicleprofileModule.self)
        mappingCoordinator?.linkItem(from: moduleJSON, clazz: VehicleprofileModule.self, linkerType: moduleLinkerType, linkLookupRuleBuilder: modulesLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Engine

        let engineJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON
        let engineLinkerType = Vehicleprofile.VehicleprofileEngineLinker.self
        let engineLookupBuilder = LinkLookupRuleBuilderObjectID(json: engineJSON, primaryKeyType: .internal, clazz: VehicleprofileEngine.self)
        mappingCoordinator?.linkItem(from: engineJSON, clazz: VehicleprofileEngine.self, linkerType: engineLinkerType, linkLookupRuleBuilder: engineLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Gun

        let gunJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON
        let gunLinkerType = Vehicleprofile.VehicleprofileGunLinker.self
        let gunLookupBuilder = LinkLookupRuleBuilderObjectID(json: gunJSON, primaryKeyType: .internal, clazz: VehicleprofileGun.self)
        mappingCoordinator?.linkItem(from: gunJSON, clazz: VehicleprofileGun.self, linkerType: gunLinkerType, linkLookupRuleBuilder: gunLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Suspension

        let suspensionJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON
        let suspensionLinkerType = Vehicleprofile.VehicleprofileSuspensionLinker.self
        let suspensionLookupBuilder = LinkLookupRuleBuilderObjectID(json: suspensionJSON, primaryKeyType: .internal, clazz: VehicleprofileSuspension.self)
        mappingCoordinator?.linkItem(from: suspensionJSON, clazz: VehicleprofileSuspension.self, linkerType: suspensionLinkerType, linkLookupRuleBuilder: suspensionLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Turret

        let turretJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON
        let turretLinkerType = Vehicleprofile.VehicleprofileTurretLinker.self
        let turretLookupBuilder = LinkLookupRuleBuilderObjectID(json: turretJSON, primaryKeyType: .internal, clazz: VehicleprofileTurret.self)
        mappingCoordinator?.linkItem(from: turretJSON, clazz: VehicleprofileTurret.self, linkerType: turretLinkerType, linkLookupRuleBuilder: turretLookupBuilder, fetchResult: vehicleProfileFetchResult)

        // MARK: - Radio

        let radioJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON
        let radioLinkerType = Vehicleprofile.VehicleprofileRadioLinker.self
        let radioLookupBuilder = LinkLookupRuleBuilderObjectID(json: radioJSON, primaryKeyType: .internal, clazz: VehicleprofileRadio.self)
        mappingCoordinator?.linkItem(from: radioJSON, clazz: VehicleprofileRadio.self, linkerType: radioLinkerType, linkLookupRuleBuilder: radioLookupBuilder, fetchResult: vehicleProfileFetchResult)
    }
}

extension Vehicleprofile {
    public class VehicleprofileRadioLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
            return .external
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
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
        override public var primaryKeyType: PrimaryKeyType { return .external }

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
