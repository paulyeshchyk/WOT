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
    @objc
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - hull

        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))
        if let fromJSON = json[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
            let armorHullMapper: JSONAdapterLinkerProtocol? = VehicleprofileArmorList.HullLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(json: fromJSON, context: context, forClass: VehicleprofileArmor.self, pkCase: hullCase, mapper: armorHullMapper) { _, error in
                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }
            }
        }

        // MARK: - turret

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        if let fromJSON = json[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
            let armorTurretMapper: JSONAdapterLinkerProtocol? = VehicleprofileArmorList.TurretLinker(masterFetchResult: masterFetchResult, mappedObjectIdentifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(json: fromJSON, context: context, forClass: VehicleprofileArmor.self, pkCase: hullCase, mapper: armorTurretMapper) { _, error in
                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }
            }
        }
    }
}

extension VehicleprofileArmorList {
    public class TurretLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let armor = fetchResult.managedObject() as? VehicleprofileArmor {
                if let armorList = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileArmorList {
                    armorList.turret = armor

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class HullLinker: BaseJSONAdapterLinker {
        override public var primaryKeyType: PrimaryKeyType { return .remote }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
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
