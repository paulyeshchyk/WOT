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

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - Penetration
        let penetrationArray = json[#keyPath(VehicleprofileAmmo.penetration)] as? [Any]
        let penetrationMapper = VehicleprofileAmmo.PenetrationLinker.self
        let penetrationRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(pkCase: pkCase, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        mappingCoordinator?.linkItems(from: penetrationArray, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoPenetration.self, mapperClazz: penetrationMapper, lookupRuleBuilder: penetrationRuleBuilder)

        // MARK: - Damage
        let damageArray = json[#keyPath(VehicleprofileAmmo.damage)] as? [Any]
        let damageMapper = VehicleprofileAmmo.DamageLinker.self
        let damageRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(pkCase: pkCase, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        mappingCoordinator?.linkItems(from: damageArray, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoDamage.self, mapperClazz: damageMapper, lookupRuleBuilder: damageRuleBuilder)
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let json = json, let entityDescription = context.entityDescription(forType: VehicleprofileAmmo.self) else {
            fatalError("Entity description not found [\(String(describing: VehicleprofileAmmo.self))]")
            return nil
        }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey
        let fetchResult = FetchResult(context: context, objectID: self.objectID, predicate: pkCase.compoundPredicate(), fetchStatus: .none)
        mappingCoordinator?.decodingAndMapping(json: json, fetchResult: fetchResult, pkCase: pkCase, mapper: nil) { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        }
    }
}

extension VehicleprofileAmmo {
    public class PenetrationLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let penetration = fetchResult.managedObject() as? VehicleprofileAmmoPenetration {
                if let ammo = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileAmmo {
                    ammo.penetration = penetration

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class DamageLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let damage = fetchResult.managedObject() as? VehicleprofileAmmoDamage {
                if let ammo = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileAmmo {
                    ammo.damage = damage

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
