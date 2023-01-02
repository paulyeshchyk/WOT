//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileArmorList {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let armorListJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        let masterFetchResult = FetchResult(objectID: objectID, inContext: managedObjectContextContainer.managedObjectContext, predicate: nil, fetchStatus: .recovered)

        // MARK: - turret

        if let jsonElement = armorListJSON[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
            let modelClass = VehicleprofileArmor.self
            let collection = try JSONCollection(element: jsonElement)
            let composer = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), parentObjectIDList: nil)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileArmorListTurretManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileArmorListError.turretNotFound, details: nil), sender: self)
        }

        // MARK: - hull

        if let jsonElement = armorListJSON[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
            let modelClass = VehicleprofileArmor.self
            let collection = try JSONCollection(element: jsonElement)
            let composer = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
            let composition = try composer.buildRequestPredicateComposition()
            let linker = VehicleprofileArmorListHullManagedObjectCreator.init(masterFetchResult: masterFetchResult, mappedObjectIdentifier: composition.objectIdentifier)
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: masterFetchResult, byModelClass: modelClass, linker: linker, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileArmorListError.hullNotFound, details: nil), sender: self)
        }
    }
}

private enum VehicleProfileArmorListError: Error, CustomStringConvertible {
    case hullNotFound
    case turretNotFound
    var description: String {
        switch self {
        case .turretNotFound: return "[\(type(of: self))]: Turret not found"
        case .hullNotFound: return "[\(type(of: self))]: Hull not found"
        }
    }
}
