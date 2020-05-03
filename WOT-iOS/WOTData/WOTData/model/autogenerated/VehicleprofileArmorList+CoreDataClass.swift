//
//  VehicleprofileArmorList+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData
import Foundation

@objc(VehicleprofileArmorList)
public class VehicleprofileArmorList: NSManagedObject {}

// MARK: - Mapping

extension VehicleprofileArmorList {
    @objc
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(context: context, fromJSON: json[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, mappingCoordinator: mappingCoordinator) { fetchResult in
            let context = fetchResult.context
            if let hull = fetchResult.managedObject() as? VehicleprofileArmor {
                self.hull = hull
                mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(context: context, fromJSON: json[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, mappingCoordinator: mappingCoordinator) { fetchResult in
            let context = fetchResult.context
            if let turret = fetchResult.managedObject() as? VehicleprofileArmor {
                self.turret = turret
                mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
}

extension VehicleprofileArmorList {
    public class LocalJSONAdapterHelper: JSONAdapterInstanceHelper {
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

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let armorList = fetchResult.managedObject() as? VehicleprofileArmorList {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.armor = armorList

                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
