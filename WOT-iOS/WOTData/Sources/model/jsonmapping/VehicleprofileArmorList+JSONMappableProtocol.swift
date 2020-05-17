//
//  VehicleprofileArmorList+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileArmorList {
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, mappingCoordinator: WOTMappingCoordinatorProtocol?, requestManager: WOTRequestManagerProtocol?) throws {
        //
        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - turret

        let turretJSON = json[#keyPath(VehicleprofileArmorList.turret)] as? JSON
        let turretBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret), parentObjectIDList: nil)
        let turretMapperClazz = VehicleprofileArmorList.TurretLinker.self
        mappingCoordinator?.linkItem(from: turretJSON, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, mapperClazz: turretMapperClazz, lookupRuleBuilder: turretBuilder, requestManager: requestManager!)

        // MARK: - hull

        let hullJSON = json[#keyPath(VehicleprofileArmorList.hull)] as? JSON
        let hullBuilder = ForeignAsPrimaryRuleBuilder(requestPredicate: requestPredicate, foreignSelectKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull), parentObjectIDList: nil)
        let hullMapperClazz = VehicleprofileArmorList.HullLinker.self
        mappingCoordinator?.linkItem(from: hullJSON, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileArmor.self, mapperClazz: hullMapperClazz, lookupRuleBuilder: hullBuilder, requestManager: requestManager!)
    }
}

extension VehicleprofileArmorList {
    public class TurretLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            guard let armor = fetchResult.managedObject() as? VehicleprofileArmor else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmor.self))
                return
            }
            guard let armorList = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileArmorList else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileArmorList.self))
                return
            }
            armorList.turret = armor
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
            }
        }
    }

    public class HullLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let armor = fetchResult.managedObject() as? VehicleprofileArmor {
                if let armorList = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileArmorList {
                    armorList.hull = armor

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
