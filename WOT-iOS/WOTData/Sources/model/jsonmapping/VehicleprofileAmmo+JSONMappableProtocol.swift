//
//  VehicleprofileAmmo+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmo {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        let vehicleprofileAmmoPenetrationCase = PKCase()
        vehicleprofileAmmoPenetrationCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        vehicleprofileAmmoPenetrationCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        if let penetrationArray = json[#keyPath(VehicleprofileAmmo.penetration)] as? [Any] {
            //
            #warning("refactoring")
            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileAmmoPenetration.self, pkCase: vehicleprofileAmmoPenetrationCase) { fetchResult in
                do {
                    let penetrationHelper: JSONAdapterInstanceHelper? = nil
                    try mappingCoordinator?.decodingAndMapping(array: penetrationArray, fetchResult: fetchResult, pkCase: vehicleprofileAmmoPenetrationCase, instanceHelper: penetrationHelper) { error in
                        self.penetration = fetchResult.managedObject() as? VehicleprofileAmmoPenetration
                        mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                            if let error = error {
                                print(error.debugDescription)
                            }
                        }
                    }
                } catch let error {
                    print(error)
                }
            }
        }
        let vehicleprofileAmmoDamageCase = PKCase()
        vehicleprofileAmmoDamageCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        vehicleprofileAmmoDamageCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))

        if let damageArray = json[#keyPath(VehicleprofileAmmo.damage)] as? [Any] {
            //
            #warning("refactoring")
            mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileAmmoDamage.self, pkCase: vehicleprofileAmmoDamageCase) { fetchResult in

                let damageHelper: JSONAdapterInstanceHelper? = nil
                do {
                    try mappingCoordinator?.decodingAndMapping(array: damageArray, fetchResult: fetchResult, pkCase: vehicleprofileAmmoDamageCase, instanceHelper: damageHelper) { error in
                        self.damage = fetchResult.managedObject() as? VehicleprofileAmmoDamage
                        mappingCoordinator?.coreDataStore?.stash(context: context) { error in
                            if let error = error {
                                print(error.debugDescription)
                            }
                        }
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, persistentStore: WOTMappingCoordinatorProtocol?) {
        guard let json = json, let entityDescription = context.entityDescription(forType: VehicleprofileAmmo.self) else {
            fatalError("Entity description not found [\(String(describing: VehicleprofileAmmo.self))]")
            return nil
        }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey
        do {
            let fetchResult = FetchResult(context: context, objectID: self.objectID, predicate: pkCase.compoundPredicate(), fetchStatus: .none, error: nil)
            try persistentStore?.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, instanceHelper: nil) { _ in }
        } catch let error {
            print(error)
        }
    }
}

extension VehicleprofileAmmo {
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
            if let ammo = fetchResult.managedObject() as? VehicleprofileAmmo {
                if let ammoList = context.object(with: objectID) as? VehicleprofileAmmoList {
                    ammoList.addToVehicleprofileAmmo(ammo)

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
