//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicleprofile {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let profileJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileJSON)
        //

        // MARK: - Link items

        var parentObjectIDList = [AnyObject]()
        parentObjectIDList.append(contentsOf: map.predicate.parentObjectIDList)
        parentObjectIDList.append(objectID)

        let vehicleProfileFetchResult = FetchResult(objectContext: managedObjectContextContainer.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        if let ammoListArray = profileJSON[#keyPath(Vehicleprofile.ammo)] as? [JSON] {
            let ammoListMapperClazz = VehicleprofileAmmoListManagedObjectCreator.self
            let ammoLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)

            let ammoListCollection = try JSONCollection(array: ammoListArray)
            let composition = try ammoLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: ammoListCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileAmmoList.self, managedObjectCreatorClass: ammoListMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noAmmoList(tank_id), details: nil), sender: self)
        }

        // MARK: - Armor

        if let armorJSON = profileJSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let armorListMapperClazz = VehicleprofileArmorListManagedObjectCreator.self
            let armorLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let armorCollection = try JSONCollection(element: armorJSON)
            let composition = try armorLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: armorCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileArmorList.self, managedObjectCreatorClass: armorListMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noArmor(tank_id), details: nil), sender: self)
        }

        // MARK: - Module

        if let moduleJSON = profileJSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let moduleMapperClazz = VehicleprofileModuleManagedObjectCreator.self
            let modulesLookupBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let moduleCollection = try JSONCollection(element: moduleJSON)
            let composition = try modulesLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: moduleCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileModule.self, managedObjectCreatorClass: moduleMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noModule(tank_id), details: nil), sender: self)
        }

        // MARK: - Engine

        if let engineJSON = profileJSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            let keypath = VehicleprofileEngine.primaryKeyPath(forType: .internal)
            let drivenObjectID = engineJSON[keypath]
            let engineMapperClazz = VehicleprofileEngineManagedObjectCreator.self
            let engineJoint = Joint(theClass: VehicleprofileEngine.self, theID: drivenObjectID, thePredicate: nil)
            let engineLookupBuilder = RootTagRuleBuilder(drivenJoint: engineJoint)
            let engineCollection = try JSONCollection(element: engineJSON)
            let composition = try engineLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: engineCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileEngine.self, managedObjectCreatorClass: engineMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noEngine(tank_id), details: nil), sender: self)
        }

        // MARK: - Gun

        if let gunJSON = profileJSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            let keypath = VehicleprofileGun.primaryKeyPath(forType: .internal)
            let drivenObjectID = gunJSON[keypath]

            let gunMapperClazz = VehicleprofileGunManagedObjectCreator.self
            let gunJoint = Joint(theClass: VehicleprofileGun.self, theID: drivenObjectID, thePredicate: nil)
            let gunLookupBuilder = RootTagRuleBuilder(drivenJoint: gunJoint)
            let gunCollection = try JSONCollection(element: gunJSON)
            let composition = try gunLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: gunCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileGun.self, managedObjectCreatorClass: gunMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noGun(tank_id), details: nil), sender: self)
        }

        // MARK: - Suspension

        if let suspensionJSON = profileJSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            let keypath = VehicleprofileSuspension.primaryKeyPath(forType: .internal)
            let drivenObjectID = suspensionJSON[keypath]
            let suspensionMapperClazz = VehicleprofileSuspensionManagedObjectCreator.self
            let suspensionJoint = Joint(theClass: VehicleprofileSuspension.self, theID: drivenObjectID, thePredicate: nil)
            let suspensionLookupBuilder = RootTagRuleBuilder(drivenJoint: suspensionJoint)
            let suspensionCollection = try JSONCollection(element: suspensionJSON)
            let composition = try suspensionLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: suspensionCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileSuspension.self, managedObjectCreatorClass: suspensionMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noSuspension(tank_id), details: nil), sender: self)
        }

        // MARK: - Turret

        if let turretJSON = profileJSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            let keypath = VehicleprofileTurret.primaryKeyPath(forType: .internal)
            let drivenObjectID = turretJSON[keypath]
            let turretMapperClazz = VehicleprofileTurretManagedObjectCreator.self
            let turretJoint = Joint(theClass: VehicleprofileSuspension.self, theID: drivenObjectID, thePredicate: nil)
            let turretLookupBuilder = RootTagRuleBuilder(drivenJoint: turretJoint)
            let turretCollection = try JSONCollection(element: turretJSON)
            let composition = try turretLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: turretCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileTurret.self, managedObjectCreatorClass: turretMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noTurret(tank_id), details: nil), sender: self)
        }

        // MARK: - Radio

        if let radioJSON = profileJSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            let keypath = VehicleprofileRadio.primaryKeyPath(forType: .internal)
            let drivenObjectID = radioJSON[keypath]
            let radioMapperClazz = VehicleprofileRadioManagedObjectCreator.self
            let radioJoint = Joint(theClass: VehicleprofileRadio.self, theID: drivenObjectID, thePredicate: nil)
            let radioLookupBuilder = RootTagRuleBuilder(drivenJoint: radioJoint)
            let radioCollection = try JSONCollection(element: radioJSON)
            let composition = try radioLookupBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: radioCollection, masterFetchResult: vehicleProfileFetchResult, linkedClazz: VehicleprofileRadio.self, managedObjectCreatorClass: radioMapperClazz, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noTurret(tank_id), details: nil), sender: self)
        }

//        try RadioLinker(appContext: appContext).link(json: profileJSON, vehicleProfileFetchResult: vehicleProfileFetchResult)
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
