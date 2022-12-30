//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension Vehicleprofile {
    // MARK: - JSONDecodableProtocol

    override public func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
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

        if let ammoListArray = profileJSON[#keyPath(Vehicleprofile.ammo)] as? [JSON] {
            let ammoListMapperClazz = VehicleprofileAmmoListManagedObjectCreator.self
            let ammoLookupBuilder = VehicleprofileAmmoListRequestPredicateComposer(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)

            let ammoListCollection = try JSONCollection(array: ammoListArray)
            appContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, managedObjectCreatorClass: ammoListMapperClazz, requestPredicateComposer: ammoLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noAmmoList(self.tank_id), details: nil), sender: self)
        }

        // MARK: - Armor

        if let armorJSON = profileJSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let armorListMapperClazz = VehicleprofileArmorListManagedObjectCreator.self
            let armorLookupBuilder = VehicleprofileArmorListRequestPredicateComposer(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let armorCollection = try JSONCollection(element: armorJSON)
            appContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, managedObjectCreatorClass: armorListMapperClazz, requestPredicateComposer: armorLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noArmor(self.tank_id), details: nil), sender: self)
        }

        // MARK: - Module

        if let moduleJSON = profileJSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let moduleMapperClazz = VehicleprofileModuleManagedObjectCreator.self
            let modulesLookupBuilder = VehicleprofileModuleRequestPredicateComposer(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let moduleCollection = try JSONCollection(element: moduleJSON)
            appContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, managedObjectCreatorClass: moduleMapperClazz, requestPredicateComposer: modulesLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noModule(self.tank_id), details: nil), sender: self)
        }

        // MARK: - Engine

        if let engineJSON = profileJSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            let engineMapperClazz = VehicleprofileEngineManagedObjectCreator.self
            let engineLookupBuilder = VehicleprofileEngineRequestPredicateComposer(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
            let engineCollection = try JSONCollection(element: engineJSON)
            appContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, managedObjectCreatorClass: engineMapperClazz, requestPredicateComposer: engineLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noEngine(self.tank_id), details: nil), sender: self)
        }

        // MARK: - Gun

        if let gunJSON = profileJSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            let gunMapperClazz = VehicleprofileGunManagedObjectCreator.self
            let gunLookupBuilder = VehicleprofileGunRequestPredicateComposer(json: gunJSON, linkedClazz: VehicleprofileGun.self)
            let gunCollection = try JSONCollection(element: gunJSON)
            appContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, managedObjectCreatorClass: gunMapperClazz, requestPredicateComposer: gunLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noGun(self.tank_id), details: nil), sender: self)
        }

        // MARK: - Suspension

        if let suspensionJSON = profileJSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            let suspensionMapperClazz = VehicleprofileSuspensionManagedObjectCreator.self
            let suspensionLookupBuilder = VehicleprofileSuspensionRequestPredicateComposer(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
            let suspensionCollection = try JSONCollection(element: suspensionJSON)
            appContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, managedObjectCreatorClass: suspensionMapperClazz, requestPredicateComposer: suspensionLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noSuspension(self.tank_id), details: nil), sender: self)
        }

        // MARK: - Turret

        if let turretJSON = profileJSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            let turretMapperClazz = VehicleprofileTurretManagedObjectCreator.self
            let turretLookupBuilder = VehicleprofileTurretRequestPredicateComposer(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
            let turretCollection = try JSONCollection(element: turretJSON)
            appContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, managedObjectCreatorClass: turretMapperClazz, requestPredicateComposer: turretLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noTurret(self.tank_id), details: nil), sender: self)
        }
        // MARK: - Radio

        if let radioJSON = profileJSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            let radioLinker = VehicleprofileRadioManagedObjectCreator.self
            let radioLookupBuilder = VehicleprofileRadioRequestPredicateComposer(json: radioJSON, linkedClazz: VehicleprofileRadio.self)
            let radioCollection = try JSONCollection(element: radioJSON)
            appContext.mappingCoordinator?.linkItem(from: radioCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, managedObjectCreatorClass: radioLinker, requestPredicateComposer: radioLookupBuilder, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noRadio(self.tank_id), details: nil), sender: self)
        }
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
