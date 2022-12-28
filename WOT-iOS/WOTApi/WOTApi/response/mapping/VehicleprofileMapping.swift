//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension Vehicleprofile {
    // MARK: - JSONMappableProtocol

    override public func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONMappableProtocol.Context) throws {
        guard let profileJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileJSON)
        //

        // MARK: - Link items

        var parentObjectIDList = map.predicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehicleProfileFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        guard let ammoListArray = profileJSON[#keyPath(Vehicleprofile.ammo)] as? [JSON] else {
            throw VehicleProfileMappingError.noAmmoList(self.tank_id)
        }
        let ammoListMapperClazz = VehicleprofileAmmoListManagedObjectCreator.self
        let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)

        let ammoListCollection = try JSONCollection(array: ammoListArray)
        appContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, managedObjectCreatorClass: ammoListMapperClazz, requestPredicateComposer: ammoLookupBuilder, appContext: appContext)

        // MARK: - Armor

        guard let armorJSON = profileJSON[#keyPath(Vehicleprofile.armor)] as? JSON else {
            throw VehicleProfileMappingError.noArmor(self.tank_id)
        }

        let armorListMapperClazz = VehicleprofileArmorListManagedObjectCreator.self
        let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let armorCollection = try JSONCollection(element: armorJSON)
        appContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, managedObjectCreatorClass: armorListMapperClazz, requestPredicateComposer: armorLookupBuilder, appContext: appContext)

        // MARK: - Module

        guard let moduleJSON = profileJSON[#keyPath(Vehicleprofile.modules)] as? JSON else {
            throw VehicleProfileMappingError.noModule(self.tank_id)
        }
        let moduleMapperClazz = VehicleprofileModuleManagedObjectCreator.self
        let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let moduleCollection = try JSONCollection(element: moduleJSON)
        appContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, managedObjectCreatorClass: moduleMapperClazz, requestPredicateComposer: modulesLookupBuilder, appContext: appContext)

        // MARK: - Engine

        guard let engineJSON = profileJSON[#keyPath(Vehicleprofile.engine)] as? JSON else {
            throw VehicleProfileMappingError.noEngine(self.tank_id)
        }
        let engineMapperClazz = VehicleprofileEngineManagedObjectCreator.self
        let engineLookupBuilder = RootTagRuleBuilder(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
        let engineCollection = try JSONCollection(element: engineJSON)
        appContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, managedObjectCreatorClass: engineMapperClazz, requestPredicateComposer: engineLookupBuilder, appContext: appContext)

        // MARK: - Gun

        guard let gunJSON = profileJSON[#keyPath(Vehicleprofile.gun)] as? JSON else {
            throw VehicleProfileMappingError.noGun(self.tank_id)
        }
        let gunMapperClazz = VehicleprofileGunManagedObjectCreator.self
        let gunLookupBuilder = RootTagRuleBuilder(json: gunJSON, linkedClazz: VehicleprofileGun.self)
        let gunCollection = try JSONCollection(element: gunJSON)
        appContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, managedObjectCreatorClass: gunMapperClazz, requestPredicateComposer: gunLookupBuilder, appContext: appContext)

        // MARK: - Suspension

        guard let suspensionJSON = profileJSON[#keyPath(Vehicleprofile.suspension)] as? JSON else {
            throw VehicleProfileMappingError.noSuspension(self.tank_id)
        }
        let suspensionMapperClazz = VehicleprofileSuspensionManagedObjectCreator.self
        let suspensionLookupBuilder = RootTagRuleBuilder(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
        let suspensionCollection = try JSONCollection(element: suspensionJSON)
        appContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, managedObjectCreatorClass: suspensionMapperClazz, requestPredicateComposer: suspensionLookupBuilder, appContext: appContext)

        // MARK: - Turret

        guard let turretJSON = profileJSON[#keyPath(Vehicleprofile.turret)] as? JSON else {
            throw VehicleProfileMappingError.noTurret(self.tank_id)
        }
        let turretMapperClazz = VehicleprofileTurretManagedObjectCreator.self
        let turretLookupBuilder = RootTagRuleBuilder(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
        let turretCollection = try JSONCollection(element: turretJSON)
        appContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, managedObjectCreatorClass: turretMapperClazz, requestPredicateComposer: turretLookupBuilder, appContext: appContext)

        // MARK: - Radio

        guard let radioJSON = profileJSON[#keyPath(Vehicleprofile.radio)] as? JSON else {
            throw VehicleProfileMappingError.noRadio(self.tank_id)
        }
        let radioLinker = VehicleprofileRadioManagedObjectCreator.self
        let radioLookupBuilder = RootTagRuleBuilder(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
        let radioCollection = try JSONCollection(element: radioJSON)
        appContext.mappingCoordinator?.linkItem(from: radioCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, managedObjectCreatorClass: radioLinker, requestPredicateComposer: radioLookupBuilder, appContext: appContext)
    }
}

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
