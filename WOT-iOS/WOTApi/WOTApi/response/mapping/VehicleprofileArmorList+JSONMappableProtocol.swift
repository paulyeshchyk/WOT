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

extension VehicleprofileArmorList {
    override public func mapping(jsonmap: JSONMapManagedObjectMapProtocol, inContext: JSONMappableProtocol.Context) throws {
        //
        let masterFetchResult = FetchResult(objectContext: jsonmap.managedObjectContext, objectID: self.objectID, predicate: nil, fetchStatus: .recovered)

        // MARK: - turret

        let turretJSON = jsonmap.json[#keyPath(VehicleprofileArmorList.turret)] as? JSON
        let turretBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), parentObjectIDList: nil)
        let turretMapperClazz = VehicleprofileArmorList.TurretLinker.self
        inContext.mappingCoordinator?.linkItem(from: turretJSON, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, mapperClazz: turretMapperClazz, lookupRuleBuilder: turretBuilder, requestManager: inContext.requestManager)

        // MARK: - hull

        let hullJSON = jsonmap.json[#keyPath(VehicleprofileArmorList.hull)] as? JSON
        let hullBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: jsonmap.predicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
        let hullMapperClazz = VehicleprofileArmorList.HullLinker.self
        inContext.mappingCoordinator?.linkItem(from: hullJSON, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, mapperClazz: hullMapperClazz, lookupRuleBuilder: hullBuilder, requestManager: inContext.requestManager)
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
