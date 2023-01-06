//
//  VehicleprofileAmmo+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmo {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer: ManagedObjectContextContainerProtocol, appContext: JSONDecodableProtocol.Context) throws {
        guard let ammoJSON = map.jsonCollection.data() as? JSON else {
            throw JSONManagedObjectMapError.notAnElement(map)
        }
        //
        try decode(decoderContainer: ammoJSON)
        //

        let vehicleprofileAmmoFetchResult = fetchResult(context: managedObjectContextContainer.managedObjectContext)

        // MARK: - Penetration

        let keypathPenetration = #keyPath(VehicleprofileAmmo.penetration)
        if let jsonCustom = ammoJSON[keypathPenetration] {
            let modelClass = VehicleprofileAmmoPenetration.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: map.predicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
            let collection = JSONCollection(custom: jsonCustom)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: keypathPenetration)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileAmmoFetchResult, anchor: anchor)
            let extractor = VehicleprofileAmmoPenetrationManagedObjectCreator()
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: vehicleprofileAmmoFetchResult, byModelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoError.noPenetration), sender: self)
        }

        // MARK: - Damage

        let keypathDamage = #keyPath(VehicleprofileAmmo.damage)
        if let jsonCustom = ammoJSON[keypathDamage] {
            let modelClass = VehicleprofileAmmoDamage.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(requestPredicate: map.predicate, foreignPrimarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo), foreignSecondarySelectKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
            let collection = JSONCollection(custom: jsonCustom)
            let composition = try composer.buildRequestPredicateComposition()
            let anchor = ManagedObjectLinkerAnchor(identifier: composition.objectIdentifier, keypath: keypathDamage)
            let linker = ManagedObjectLinker(modelClass: modelClass, masterFetchResult: vehicleprofileAmmoFetchResult, anchor: anchor)
            let extractor = VehicleprofileAmmoDamageManagedObjectCreator()
            try appContext.mappingCoordinator?.linkItem(from: collection, masterFetchResult: vehicleprofileAmmoFetchResult, byModelClass: modelClass, linker: linker, extractor: extractor, requestPredicateComposition: composition, appContext: appContext)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoError.noDamage), sender: self)
        }
    }
}

// MARK: - VehicleprofileAmmoError

public enum VehicleprofileAmmoError: Error, CustomStringConvertible {
    case noPenetration
    case noDamage

    public var description: String {
        switch self {
        case .noPenetration: return "[\(type(of: self))]: No penetration"
        case .noDamage: return "[\(type(of: self))]: No damage"
        }
    }
}
