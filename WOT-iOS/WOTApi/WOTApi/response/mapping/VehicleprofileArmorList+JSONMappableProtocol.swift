//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import ContextSDK

// MARK: - JSONMappableProtocol

private enum VehicleProfileArmorListError: Error, CustomStringConvertible {
    case hullNotFound
    case turretNotFound
    var description: String {
        switch self {
        case .turretNotFound: return "[\(type(of: self))]: Turret to found"
        case .hullNotFound: return "[\(type(of: self))]: Hull to found"
        }
    }
}

extension VehicleprofileArmorList {
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
        let turretMapperClazz = VehicleprofileArmorList.TurretLinker.self
        inContext.mappingCoordinator?.linkItem(from: turretJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, mapperClazz: turretMapperClazz, lookupRuleBuilder: turretBuilder, requestManager: inContext.requestManager)

        // MARK: - hull

        guard let hullJSON = armorList[#keyPath(VehicleprofileArmorList.hull)] as? JSON else {
            throw VehicleProfileArmorListError.hullNotFound
        }
        let hullJSONCollection = try JSONCollection(element: hullJSON)
        
        let hullBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: map.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
        let hullMapperClazz = VehicleprofileArmorList.HullLinker.self
        inContext.mappingCoordinator?.linkItem(from: hullJSONCollection, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, mapperClazz: hullMapperClazz, lookupRuleBuilder: hullBuilder, requestManager: inContext.requestManager)
    }
}

extension VehicleprofileArmorList {
    public class TurretLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            guard let armor = fetchResult.managedObject() as? VehicleprofileArmor else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
                return
            }
            guard let armorList = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileArmorList else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmorList.self))
                return
            }
            armorList.turret = armor
            dataStore?.stash(objectContext: managedObjectContext) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class HullLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
            let managedObjectContext = fetchResult.objectContext
            if let armor = fetchResult.managedObject() as? VehicleprofileArmor {
                if let armorList = masterFetchResult?.managedObject(inManagedObjectContext: managedObjectContext) as? VehicleprofileArmorList {
                    armorList.hull = armor

                    dataStore?.stash(objectContext: managedObjectContext) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
