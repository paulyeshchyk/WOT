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
        let masterFetchResult = FetchResult(objectContext: managedObjectContextContainer.managedObjectContext, objectID: objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - turret

        if let turretJSON = armorListJSON[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
            let turretJSONCollection = try JSONCollection(element: turretJSON)

            let turretBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), parentObjectIDList: nil)
            let turretMapperClazz = VehicleprofileArmorListTurretManagedObjectCreator.self
            let turretComposition = try turretBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: turretJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, managedObjectCreatorClass: turretMapperClazz, requestPredicateComposition: turretComposition, appContext: appContext)
        } else {
            appContext.logInspector?.logEvent(EventWarning(error: VehicleProfileArmorListError.turretNotFound, details: nil), sender: self)
        }

        // MARK: - hull

        if let hullJSON = armorListJSON[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
            let hullJSONCollection = try JSONCollection(element: hullJSON)

            let hullBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
            let hullMapperClazz = VehicleprofileArmorListHullManagedObjectCreator.self
            let composition = try hullBuilder.buildRequestPredicateComposition()
            try appContext.mappingCoordinator?.linkItem(from: hullJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, managedObjectCreatorClass: hullMapperClazz, requestPredicateComposition: composition, appContext: appContext)
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
