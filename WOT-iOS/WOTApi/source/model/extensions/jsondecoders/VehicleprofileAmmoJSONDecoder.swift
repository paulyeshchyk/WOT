//
//  VehicleprofileAmmoJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoJSONDecoder

class VehicleprofileAmmoJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel: DecodingDepthLevel?) throws {
        //
        let ammoJSON = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: ammoJSON)
        //

        // MARK: - Penetration

        let keypathPenetration = #keyPath(VehicleprofileAmmo.penetration)
        if let jsonCustom = ammoJSON?[keypathPenetration] {
            let foreignPrimarySelectKey = #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo)
            let foreignSecondarySelectKey = #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo)
            let modelClass = VehicleprofileAmmoPenetration.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(jsonMap: map, foreignPrimarySelectKey: foreignPrimarySelectKey, foreignSecondarySelectKey: foreignSecondarySelectKey)
            let composition = try composer.buildRequestPredicateComposition()
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileAmmoError.invalidManagedRef
            }

            let socket = JointSocket(managedRef: managedRef, identifier: composition.objectIdentifier, keypath: keypathPenetration)
            let jsonMap = try JSONMap(data: jsonCustom, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            let config = UoW_Config__Fetch_Decode_Link(appContext: appContext,
                                                       modelClass: modelClass,
                                                       socket: socket,
                                                       jsonMaps: [jsonMap],
                                                       decodingDepthLevel: decodingDepthLevel)
            let uow = try appContext.uowManager.uow(by: config)
            try appContext.uowManager.perform(uow: uow)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoError.noPenetration), sender: self)
        }

        // MARK: - Damage

        let keypathDamage = #keyPath(VehicleprofileAmmo.damage)
        if let jsonCustom = ammoJSON?[keypathDamage] {
            let foreignPrimarySelectKey = #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo)
            let foreignSecondarySelectKey = #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo)
            let modelClass = VehicleprofileAmmoDamage.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(jsonMap: map, foreignPrimarySelectKey: foreignPrimarySelectKey, foreignSecondarySelectKey: foreignSecondarySelectKey)
            let composition = try composer.buildRequestPredicateComposition()
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileAmmoError.invalidManagedRef
            }

            let socket = JointSocket(managedRef: managedRef, identifier: composition.objectIdentifier, keypath: keypathDamage)
            let jsonMap = try JSONMap(data: jsonCustom, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            let config = UoW_Config__Fetch_Decode_Link(appContext: appContext,
                                                       modelClass: modelClass,
                                                       socket: socket,
                                                       jsonMaps: [jsonMap],
                                                       decodingDepthLevel: decodingDepthLevel)
            let uow = try appContext.uowManager.uow(by: config)
            try appContext.uowManager.perform(uow: uow)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoError.noDamage), sender: self)
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
    case invalidManagedRef

    public var description: String {
        switch self {
        case .noPenetration: return "[\(type(of: self))]: No penetration"
        case .noDamage: return "[\(type(of: self))]: No damage"
        case .invalidManagedRef: return "[\(type(of: self))]: Invalid managedRef"
        }
    }
}
