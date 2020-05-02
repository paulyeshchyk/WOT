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
    override public func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        let hullCase = PKCase()
        hullCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull))

        VehicleprofileArmor.hull(context: context, fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { fetchResult in
            let context = fetchResult.context
            if let hull = fetchResult.managedObject() as? VehicleprofileArmor {
                self.hull = hull
                persistentStore?.stash(context: context, hint: hullCase) { error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                }
            }
        }

        let turretCase = PKCase()
        turretCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret))
        VehicleprofileArmor.turret(context: context, fromJSON: jSON[#keyPath(VehicleprofileArmorList.hull)], pkCase: hullCase, persistentStore: persistentStore) { fetchResult in
            let context = fetchResult.context
            if let turret = fetchResult.managedObject() as? VehicleprofileArmor {
                self.turret = turret
                persistentStore?.stash(context: context, hint: hullCase) { error in
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

        private var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let armorList = fetchResult.managedObject() as? VehicleprofileArmorList {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.armor = armorList

                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
