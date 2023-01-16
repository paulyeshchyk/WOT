//
//  VehicleprofileAmmoJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoJSONDecoder

class VehicleprofileAmmoJSONDecoder: JSONDecoderProtocol {

    var managedObject: (VehicleprofileAmmo & DecodableProtocol & ManagedObjectProtocol)?

    func decode(using map: JSONMapProtocol, appContext: (DataStoreContainerProtocol & LogInspectorContainerProtocol & RequestManagerContainerProtocol)?, forDepthLevel: DecodingDepthLevel?) throws {
        guard let managedObject = managedObject else {
            return
        }
        //
        let ammoJSON = try map.data(ofType: JSON.self)
        try managedObject.decode(decoderContainer: ammoJSON)
        //

        // MARK: - Penetration

        let keypathPenetration = #keyPath(VehicleprofileAmmo.penetration)
        if let jsonCustom = ammoJSON?[keypathPenetration] {
            let foreignPrimarySelectKey = #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo)
            let foreignSecondarySelectKey = #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo)
            let modelClass = VehicleprofileAmmoPenetration.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(jsonMap: map, foreignPrimarySelectKey: foreignPrimarySelectKey, foreignSecondarySelectKey: foreignSecondarySelectKey)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject.managedRef, identifier: composition.objectIdentifier, keypath: keypathPenetration)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(custom: jsonCustom, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleprofileAmmoError.noPenetration), sender: self)
        }

        // MARK: - Damage

        let keypathDamage = #keyPath(VehicleprofileAmmo.damage)
        if let jsonCustom = ammoJSON?[keypathDamage] {
            let foreignPrimarySelectKey = #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo)
            let foreignSecondarySelectKey = #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo)
            let modelClass = VehicleprofileAmmoDamage.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(jsonMap: map, foreignPrimarySelectKey: foreignPrimarySelectKey, foreignSecondarySelectKey: foreignSecondarySelectKey)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject.managedRef, identifier: composition.objectIdentifier, keypath: keypathDamage)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(custom: jsonCustom, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleprofileAmmoError.noDamage), sender: self)
        }
    }
}

extension VehicleprofileAmmo {

    private class DamageExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class PenetrationExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
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
