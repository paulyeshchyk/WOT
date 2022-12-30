//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicleprofile {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONManagedObjectMapProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profileJSON = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileJSON)
        //

        // MARK: - Link items

        var parentObjectIDList = map.predicate.parentObjectIDList
        parentObjectIDList.append(objectID)

        let vehicleProfileFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        if let ammoListArray = profileJSON[#keyPath(Vehicleprofile.ammo)] as? [JSON] {
            let ammoListMapperClazz = VehicleprofileAmmoListManagedObjectCreator.self
            let ammoLookupBuilder = VehicleprofileAmmoListRequestPredicateComposer(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)

            let ammoListCollection = try JSONCollection(array: ammoListArray)
            let composition = try ammoLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, managedObjectCreatorClass: ammoListMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noAmmoList(tank_id), details: nil), sender: self)
        }

        // MARK: - Armor

        if let armorJSON = profileJSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let armorListMapperClazz = VehicleprofileArmorListManagedObjectCreator.self
            let armorLookupBuilder = VehicleprofileArmorListRequestPredicateComposer(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let armorCollection = try JSONCollection(element: armorJSON)
            let composition = try armorLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, managedObjectCreatorClass: armorListMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noArmor(tank_id), details: nil), sender: self)
        }

        // MARK: - Module

        if let moduleJSON = profileJSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let moduleMapperClazz = VehicleprofileModuleManagedObjectCreator.self
            let modulesLookupBuilder = VehicleprofileModuleRequestPredicateComposer(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let moduleCollection = try JSONCollection(element: moduleJSON)
            let composition = try modulesLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, managedObjectCreatorClass: moduleMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noModule(tank_id), details: nil), sender: self)
        }

        // MARK: - Engine

        if let engineJSON = profileJSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            let engineMapperClazz = VehicleprofileEngineManagedObjectCreator.self
            let engineLookupBuilder = VehicleprofileEngineRequestPredicateComposer(json: engineJSON, linkedClazz: VehicleprofileEngine.self)
            let engineCollection = try JSONCollection(element: engineJSON)
            let composition = try engineLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, managedObjectCreatorClass: engineMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noEngine(tank_id), details: nil), sender: self)
        }

        // MARK: - Gun

        if let gunJSON = profileJSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            let gunMapperClazz = VehicleprofileGunManagedObjectCreator.self
            let gunLookupBuilder = VehicleprofileGunRequestPredicateComposer(json: gunJSON, linkedClazz: VehicleprofileGun.self)
            let gunCollection = try JSONCollection(element: gunJSON)
            let composition = try gunLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, managedObjectCreatorClass: gunMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noGun(tank_id), details: nil), sender: self)
        }

        // MARK: - Suspension

        if let suspensionJSON = profileJSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            let suspensionMapperClazz = VehicleprofileSuspensionManagedObjectCreator.self
            let suspensionLookupBuilder = VehicleprofileSuspensionRequestPredicateComposer(json: suspensionJSON, linkedClazz: VehicleprofileSuspension.self)
            let suspensionCollection = try JSONCollection(element: suspensionJSON)
            let composition = try suspensionLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, managedObjectCreatorClass: suspensionMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noSuspension(tank_id), details: nil), sender: self)
        }

        // MARK: - Turret

        if let turretJSON = profileJSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            let turretMapperClazz = VehicleprofileTurretManagedObjectCreator.self
            let turretLookupBuilder = VehicleprofileTurretRequestPredicateComposer(json: turretJSON, linkedClazz: VehicleprofileTurret.self)
            let turretCollection = try JSONCollection(element: turretJSON)
            let composition = try turretLookupBuilder.build()
            try appContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, managedObjectCreatorClass: turretMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noTurret(tank_id), details: nil), sender: self)
        }

        // MARK: - Radio

        try RadioLinker(appContext: appContext).link(json: profileJSON, vehicleProfileFetchResult: vehicleProfileFetchResult)
    }
}

class RadioLinker {
    var keyPath: AnyHashable { #keyPath(Vehicleprofile.radio) }
    var managedObjectCreator: ManagedObjectCreatorProtocol.Type { return VehicleprofileRadioManagedObjectCreator.self }
    var linkedClass: ContextSDK.PrimaryKeypathProtocol.Type { VehicleprofileRadio.self }

    private let appContext: JSONDecodableProtocol.Context
    init(appContext: JSONDecodableProtocol.Context) {
        self.appContext = appContext
    }

    func link(json: JSON, vehicleProfileFetchResult masterFetchResult: FetchResult) throws {
        guard let radioJSON = json[keyPath] as? JSON else {
            throw VehicleProfileMappingError.noRadio(-1)
        }
        let radioCollection = try JSONCollection(element: radioJSON)
        let composition = try VehicleprofileRadioRequestPredicateComposer(json: radioJSON, linkedClazz: linkedClass).build()
        try appContext.mappingCoordinator?.linkItem(from: radioCollection,
                                                    masterFetchResult: masterFetchResult,
                                                    linkedClazz: linkedClass,
                                                    managedObjectCreatorClass: managedObjectCreator,
                                                    requestPredicateComposition: composition,
                                                    appContext: appContext)
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
