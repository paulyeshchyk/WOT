//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

extension VehicleprofileArmorList {
    // MARK: - JSONMappableProtocol

    override public func mapping(with map: JSONManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        guard let armorList = map.mappingData as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        let masterFetchResult = FetchResult(objectContext: map.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - turret

        guard let turretJSON = armorList[#keyPath(VehicleprofileArmorList.turret)] as? JSON else {
            throw VehicleProfileArmorListError.turretNotFound
        }

        let turretJSONCollection = try JSONCollection(element: turretJSON)

        let turretBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), parentObjectIDList: nil)
        let turretMapperClazz = VehicleprofileArmorListTurretManagedObjectCreator.self
        inContext.mappingCoordinator?.linkItem(from: turretJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, managedObjectCreatorClass: turretMapperClazz, lookupRuleBuilder: turretBuilder, appContext: inContext)

        // MARK: - hull

        guard let hullJSON = armorList[#keyPath(VehicleprofileArmorList.hull)] as? JSON else {
            throw VehicleProfileArmorListError.hullNotFound
        }
        let hullJSONCollection = try JSONCollection(element: hullJSON)

        let hullBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
        let hullMapperClazz = VehicleprofileArmorListHullManagedObjectCreator.self
        inContext.mappingCoordinator?.linkItem(from: hullJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, managedObjectCreatorClass: hullMapperClazz, lookupRuleBuilder: hullBuilder, appContext: inContext)
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
