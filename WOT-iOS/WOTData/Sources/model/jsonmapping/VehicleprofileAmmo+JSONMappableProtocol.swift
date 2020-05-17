//
//  VehicleprofileAmmo+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension VehicleprofileAmmo {
    override public func mapping(json: JSON, context: NSManagedObjectContext, requestPredicate: RequestPredicate, fetcher: WOTFetcherProtocol?, linker: WOTLinkerProtocol?, fetcherAndDecoder: WOTFetchAndDecodeProtocol?, decoderAndMapper: WOTDecodeAndMappingProtocol) throws {
        //
        try self.decode(json: json)
        //

        let masterFetchResult = FetchResult(context: context, objectID: self.objectID, predicate: nil, fetchStatus: .none)

        // MARK: - Penetration

        let penetrationArray = json[#keyPath(VehicleprofileAmmo.penetration)] as? [Any]
        let penetrationMapper = VehicleprofileAmmo.PenetrationLinker.self
        let penetrationRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: requestPredicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        linker?.linkItems(from: penetrationArray, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoPenetration.self, mapperClazz: penetrationMapper, lookupRuleBuilder: penetrationRuleBuilder)

        // MARK: - Damage

        let damageArray = json[#keyPath(VehicleprofileAmmo.damage)] as? [Any]
        let damageMapper = VehicleprofileAmmo.DamageLinker.self
        let damageRuleBuilder = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: requestPredicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        linker?.linkItems(from: damageArray, masterFetchResult: masterFetchResult, linkedClazz: VehicleprofileAmmoDamage.self, mapperClazz: damageMapper, lookupRuleBuilder: damageRuleBuilder)
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: RequestExpression?, forRequest: WOTRequestProtocol, decoderAndMapper: WOTDecodeAndMappingProtocol) {
        guard let json = json, let entityDescription = context.entityDescription(forType: VehicleprofileAmmo.self) else {
            fatalError("Entity description not found [\(String(describing: VehicleprofileAmmo.self))]")
            return nil
        }
        self.init(entity: entityDescription, insertInto: context)

        let ammoPredicate = RequestPredicate()
        ammoPredicate[.primary] = parentPrimaryKey
        let fetchResult = FetchResult(context: context, objectID: self.objectID, predicate: ammoPredicate.compoundPredicate(.and), fetchStatus: .none)
        decoderAndMapper.decodingAndMapping(json: json, fetchResult: fetchResult, requestPredicate: ammoPredicate, mapper: nil, completion: { _, _ in })
    }
}

extension VehicleprofileAmmo {
    public class PenetrationLinker: BaseJSONAdapterLinker {
        override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }

        override public func onJSONExtraction(json: JSON) -> JSON { return json }

        override public func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            guard let penetration = fetchResult.managedObject() as? VehicleprofileAmmoPenetration else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoPenetration.self))
                return
            }
            guard let ammo = masterFetchResult?.managedObject(inContext: context) as? VehicleprofileAmmo else {
                completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
                return
            }

            ammo.penetration = penetration
            coreDataStore?.stash(context: context) { error in
                completion(fetchResult, error)
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
