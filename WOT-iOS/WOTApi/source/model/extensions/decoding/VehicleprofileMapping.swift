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

        let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)

        // MARK: - AmmoList

        if let jsonArray = profileJSON[#keyPath(Vehicleprofile.ammo)] as? [JSON] {
            let modelClass = VehicleprofileAmmoList.self
            let composer = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let collection = try JSONCollection(array: jsonArray)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileAmmoListManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noAmmoList(tank_id), details: nil), sender: self)
        }

        // MARK: - Armor

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.armor)] as? JSON {
            let modelClass = VehicleprofileArmorList.self
            let composer = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileArmorListManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noArmor(tank_id), details: nil), sender: self)
        }

        // MARK: - Module

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.modules)] as? JSON {
            let modelClass = VehicleprofileModule.self
            let composer = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileModuleManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noModule(tank_id), details: nil), sender: self)
        }

        // MARK: - Engine

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.engine)] as? JSON {
            let keypath = VehicleprofileEngine.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileEngine.self
            let joint = Joint(theClass: modelClass, theID: drivenObjectID, thePredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileEngineManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noEngine(tank_id), details: nil), sender: self)
        }

        // MARK: - Gun

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.gun)] as? JSON {
            let keypath = VehicleprofileGun.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileGun.self
            let joint = Joint(theClass: modelClass, theID: drivenObjectID, thePredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileGunManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noGun(tank_id), details: nil), sender: self)
        }

        // MARK: - Suspension

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.suspension)] as? JSON {
            let keypath = VehicleprofileSuspension.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileSuspension.self
            let joint = Joint(theClass: modelClass, theID: drivenObjectID, thePredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileSuspensionManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noSuspension(tank_id), details: nil), sender: self)
        }

        // MARK: - Turret

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.turret)] as? JSON {
            let keypath = VehicleprofileTurret.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileSuspension.self
            let joint = Joint(theClass: modelClass, theID: drivenObjectID, thePredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileTurretManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            let collection = try JSONCollection(element: jsonElement)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noTurret(tank_id), details: nil), sender: self)
        }

        // MARK: - Radio

        if let jsonElement = profileJSON[#keyPath(Vehicleprofile.radio)] as? JSON {
            let keypath = VehicleprofileRadio.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileRadio.self
            let joint = Joint(theClass: modelClass, theID: drivenObjectID, thePredicate: nil)
            let composer = RootTagRuleBuilder(drivenJoint: joint)
            let collection = try JSONCollection(element: jsonElement)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileRadioManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileMappingError.noTurret(tank_id), details: nil), sender: self)
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
