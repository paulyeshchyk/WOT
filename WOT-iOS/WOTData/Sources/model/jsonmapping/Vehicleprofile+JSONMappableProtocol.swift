//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension Vehicleprofile {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        var parents = pkCase.plainParents
        parents.append(self)

        if let itemJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON {
            if let itemID = itemJSON[VehicleprofileGun.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileGun.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleprofileGun.LocalJSONAdapterHelper(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileGun.self, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in })
            }
        }

        if let itemsList = json[#keyPath(Vehicleprofile.ammo)] as? [Any] {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
            let instanceHelper = VehicleprofileAmmoList.LocalJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(array: itemsList, context: context, forClass: VehicleprofileAmmoList.self, pkCase: itemCase, instanceHelper: instanceHelper, callback: { _ in })
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
            let instanceHelper = VehicleprofileArmorList.LocalJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileArmorList.self, pkCase: itemCase, instanceHelper: instanceHelper, callback: { _ in })
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON {
            if let itemID = itemJSON[VehicleprofileSuspension.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileSuspension.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleprofileSuspension.LocalJSONAdapterHelper(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileSuspension.self, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in })
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON {
            if let itemID = itemJSON[VehicleprofileRadio.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileRadio.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleprofileRadio.LocalJSONAdapterHelper(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileRadio.self, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in})
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON {
            if let itemID = itemJSON[VehicleprofileEngine.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileEngine.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleprofileEngine.LocalJSONAdapterHelper(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileEngine.self, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in})
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON {
            if let itemID = itemJSON[VehicleprofileTurret.primaryKeyPath(forType: .internal)] {
                let pkCase = PKCase()
                pkCase[.primary] = VehicleprofileTurret.primaryKey(for: itemID, andType: .internal)
                let instanceHelper = VehicleprofileTurret.LocalJSONAdapterHelper(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileTurret.self, pkCase: pkCase, instanceHelper: instanceHelper, callback: { _ in})
            }
        }

        if let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON {
            let vehicleprofileModuleCase = PKCase(parentObjects: parents)
            vehicleprofileModuleCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
            let instanceHelper = VehicleprofileModule.LocalJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(json: moduleJSON, context: context, forClass: VehicleprofileModule.self, pkCase: vehicleprofileModuleCase, instanceHelper: instanceHelper, callback: { _ in })
        }
    }
}
