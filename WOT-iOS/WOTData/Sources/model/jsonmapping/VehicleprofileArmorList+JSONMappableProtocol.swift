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
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))
        if let fromJSON = json[#keyPath(VehicleprofileArmorList.hull)] as? JSON {
            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: hullCase) { fetchResult, error in
                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }
                let armorHullLinker: JSONAdapterLinkerProtocol? = VehicleprofileArmorList.VehicleprofileArmorListHullLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.decodingAndMapping(json: fromJSON, fetchResult: fetchResult, pkCase: hullCase, linker: armorHullLinker) { _, error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        return
                    }
                }
            }
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        if let fromJSON = json[#keyPath(VehicleprofileArmorList.turret)] as? JSON {
            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: hullCase) { fetchResult, error in
                if let error = error {
                    mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                    return
                }
                let armorHullLinker: JSONAdapterLinkerProtocol? = VehicleprofileArmorList.VehicleprofileArmorListTurretLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.decodingAndMapping(json: fromJSON, fetchResult: fetchResult, pkCase: hullCase, linker: armorHullLinker) { _, error in
                    if let error = error {
                        mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                        return
                    }
                }
            }
        }
    }
}

extension VehicleprofileArmorList {
    public class VehicleprofileArmorListTurretLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let armor = fetchResult.managedObject() as? VehicleprofileArmor {
                if let armorList = context.object(with: objectID) as? VehicleprofileArmorList {
                    armorList.turret = armor

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileArmorListHullLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let armor = fetchResult.managedObject() as? VehicleprofileArmor {
                if let armorList = context.object(with: objectID) as? VehicleprofileArmorList {
                    armorList.hull = armor

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
