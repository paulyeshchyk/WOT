//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension Vehicleprofile {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let profile = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profile)
        //

        // MARK: - Link items

        var parentObjectIDList = map.predicate.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        let vehicleProfileFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        guard let ammoListArray = profile[#keyPath(Vehicleprofile.ammo)] as? [JSON] else {
            throw VehicleProfileMappingError.noAmmoList(self.tank_id)
        }
        let ammoListMapperClazz = VehicleprofileAmmoListManagedObjectCreator.self
        let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)

        let ammoListCollection = try JSONCollection(array: ammoListArray)
        inContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, managedObjectCreatorClass: ammoListMapperClazz, lookupRuleBuilder: ammoLookupBuilder, appContext: inContext)

        // MARK: - Armor

        guard let armorJSON = profile[#keyPath(Vehicleprofile.armor)] as? JSON else {
            throw VehicleProfileMappingError.noArmor(self.tank_id)
        }

        let armorListMapperClazz = VehicleprofileArmorListManagedObjectCreator.self
        let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let armorCollection = try JSONCollection(element: armorJSON)
        inContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, managedObjectCreatorClass: armorListMapperClazz, lookupRuleBuilder: armorLookupBuilder, appContext: inContext)

        // MARK: - Module

        guard let moduleJSON = profile[#keyPath(Vehicleprofile.modules)] as? JSON else {
            throw VehicleProfileMappingError.noModule(self.tank_id)
        }
        let moduleMapperClazz = VehicleprofileModuleManagedObjectCreator.self
        let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
        let moduleCollection = try JSONCollection(element: moduleJSON)
        inContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, managedObjectCreatorClass: moduleMapperClazz, lookupRuleBuilder: modulesLookupBuilder, appContext: inContext)

        // MARK: - Engine

        guard let engineJSON = profile[#keyPath(Vehicleprofile.engine)] as? JSON else {
            throw VehicleProfileMappingError.noEngine(self.tank_id)
        }
        let engineMapperClazz = VehicleprofileEngineManagedObjectCreator.self
        let engineLookupBuilder = RootTagRuleBuilder(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
        let engineCollection = try JSONCollection(element: engineJSON)
        inContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, managedObjectCreatorClass: engineMapperClazz, lookupRuleBuilder: engineLookupBuilder, appContext: inContext)

        // MARK: - Gun

        guard let gunJSON = profile[#keyPath(Vehicleprofile.gun)] as? JSON else {
            throw VehicleProfileMappingError.noGun(self.tank_id)
        }
        let gunMapperClazz = VehicleprofileGunManagedObjectCreator.self
        let gunLookupBuilder = RootTagRuleBuilder(json: gunJSON, linkedClazz: VehicleprofileGun.self)
        let gunCollection = try JSONCollection(element: gunJSON)
        inContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, managedObjectCreatorClass: gunMapperClazz, lookupRuleBuilder: gunLookupBuilder, appContext: inContext)

        // MARK: - Suspension

        guard let suspensionJSON = profile[#keyPath(Vehicleprofile.suspension)] as? JSON else {
            throw VehicleProfileMappingError.noSuspension(self.tank_id)
        }
        let suspensionMapperClazz = VehicleprofileSuspensionManagedObjectCreator.self
        let suspensionLookupBuilder = RootTagRuleBuilder(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
        let suspensionCollection = try JSONCollection(element: suspensionJSON)
        inContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, managedObjectCreatorClass: suspensionMapperClazz, lookupRuleBuilder: suspensionLookupBuilder, appContext: inContext)

        // MARK: - Turret

        guard let turretJSON = profile[#keyPath(Vehicleprofile.turret)] as? JSON else {
            throw VehicleProfileMappingError.noTurret(self.tank_id)
        }
        let turretMapperClazz = VehicleprofileTurretManagedObjectCreator.self
        let turretLookupBuilder = RootTagRuleBuilder(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
        let turretCollection = try JSONCollection(element: turretJSON)
        inContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, managedObjectCreatorClass: turretMapperClazz, lookupRuleBuilder: turretLookupBuilder, appContext: inContext)

        // MARK: - Radio

        guard let radioJSON = profile[#keyPath(Vehicleprofile.radio)] as? JSON else {
            throw VehicleProfileMappingError.noRadio(self.tank_id)
        }
        let radioLinker = VehicleprofileRadioManagedObjectCreator.self
        let radioLookupBuilder = RootTagRuleBuilder(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
        let radioCollection = try JSONCollection(element: radioJSON)
        inContext.mappingCoordinator?.linkItem(from: radioCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, managedObjectCreatorClass: radioLinker, lookupRuleBuilder: radioLookupBuilder, appContext: inContext)
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
