//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension Vehicleprofile {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context?) throws {
        guard let profileJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: profileJSON)
        //

        // MARK: - Link items

        var parentObjectIDList = [AnyObject]()
        parentObjectIDList.append(contentsOf: map.contextPredicate.parentObjectIDList)
        parentObjectIDList.append(objectID)

        let vehicleprofileFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        // MARK: - AmmoList

        let ammoKeypath = #keyPath(Vehicleprofile.ammo)
        if let jsonArray = profileJSON[ammoKeypath] as? [JSON] {
            let modelClass = VehicleprofileAmmoList.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let collection = try JSONCollection(array: jsonArray)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: ammoKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileAmmoListManagedObjectCreator()
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noAmmoList(tank_id)), sender: self)
        }

        // MARK: - Armor

        let armorKeypath = #keyPath(Vehicleprofile.armor)
        if let jsonElement = profileJSON[armorKeypath] as? JSON {
            let modelClass = VehicleprofileArmorList.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: armorKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extactor = VehicleprofileArmorListManagedObjectCreator()
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extactor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noArmor(tank_id)), sender: self)
        }

        // MARK: - Module

        let modulesKeypath = #keyPath(Vehicleprofile.modules)
        if let jsonElement = profileJSON[modulesKeypath] as? JSON {
            let modelClass = VehicleprofileModule.self
            let composer = ForeignAsPrimaryRuleBuilder(contextPredicate: map.contextPredicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: modulesKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileModuleManagedObjectCreator()
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noModule(tank_id)), sender: self)
        }

        // MARK: - Engine

        let engineKeypath = #keyPath(Vehicleprofile.engine)
        if let jsonElement = profileJSON[engineKeypath] as? JSON {
            let keypath = VehicleprofileEngine.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileEngine.self
            let joint = Joint(modelClass: modelClass, theID: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: engineKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileEngineManagedObjectCreator()
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noEngine(tank_id)), sender: self)
        }

        // MARK: - Gun

        let gunKeypath = #keyPath(Vehicleprofile.gun)
        if let jsonElement = profileJSON[gunKeypath] as? JSON {
            let modelClass = VehicleprofileGun.self
            let keypath = VehicleprofileGun.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let joint = Joint(modelClass: modelClass, theID: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: gunKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileGunManagedObjectCreator()
            let collection = try JSONCollection(element: jsonElement)
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noGun(tank_id)), sender: self)
        }

        // MARK: - Suspension

        let suspensionKeypath = #keyPath(Vehicleprofile.suspension)
        if let jsonElement = profileJSON[suspensionKeypath] as? JSON {
            let keypath = VehicleprofileSuspension.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileSuspension.self
            let joint = Joint(modelClass: modelClass, theID: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: suspensionKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileSuspensionManagedObjectCreator()
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noSuspension(tank_id)), sender: self)
        }

        // MARK: - Turret

        let turretKeypath = #keyPath(Vehicleprofile.turret)
        if let jsonElement = profileJSON[turretKeypath] as? JSON {
            let keypath = VehicleprofileTurret.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileTurret.self
            let joint = Joint(modelClass: modelClass, theID: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: turretKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileTurretManagedObjectCreator()
            let collection = try JSONCollection(element: jsonElement)
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noTurret(tank_id)), sender: self)
        }

        // MARK: - Radio

        let radioKeypath = #keyPath(Vehicleprofile.radio)
        if let jsonElement = profileJSON[radioKeypath] as? JSON {
            let keypath = VehicleprofileRadio.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileRadio.self
            let joint = Joint(modelClass: modelClass, theID: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: radioKeypath)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileFetchResult, anchor: anchor)
            let extractor = VehicleprofileRadioManagedObjectCreator()
            try appContext?.mappingCoordinator?.linkItem(jsonCollection: collection, masterFetchResult: vehicleprofileFetchResult, modelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition)
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noTurret(tank_id)), sender: self)
        }
    }
}

// MARK: - VehicleProfileMappingError

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
