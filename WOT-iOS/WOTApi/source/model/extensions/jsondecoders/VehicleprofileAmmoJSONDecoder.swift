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

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        // MARK: - Penetration

        let keypathPenetration = #keyPath(VehicleprofileAmmo.penetration)
        if let jsonCustom = element[keypathPenetration] {
            let foreignPrimarySelectKey = #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo)
            let foreignSecondarySelectKey = #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo)
            let modelClass = VehicleprofileAmmoPenetration.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(jsonMap: map, foreignPrimarySelectKey: foreignPrimarySelectKey, foreignSecondarySelectKey: foreignSecondarySelectKey)
            let contextPredicate = try composer.buildRequestPredicateComposition()
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileAmmoError.invalidManagedRef
            }

            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypathPenetration)
            let jsonMap = try JSONMap(data: jsonCustom, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoError.noPenetration), sender: self)
        }

        // MARK: - Damage

        let keypathDamage = #keyPath(VehicleprofileAmmo.damage)
        if let jsonCustom = element[keypathDamage] {
            let foreignPrimarySelectKey = #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo)
            let foreignSecondarySelectKey = #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo)
            let modelClass = VehicleprofileAmmoDamage.self
            let composer = ForeignAsPrimaryAndForeignSecondaryRuleBuilder(jsonMap: map, foreignPrimarySelectKey: foreignPrimarySelectKey, foreignSecondarySelectKey: foreignSecondarySelectKey)
            let contextPredicate = try composer.buildRequestPredicateComposition()

            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileAmmoError.invalidManagedRef
            }

            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypathDamage)
            let jsonMap = try JSONMap(data: jsonCustom, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoError.noDamage), sender: self)
        }
    }
}

// MARK: - %t + VehicleprofileAmmoJSONDecoder.VehicleprofileAmmoJSONDecoderErrors

extension VehicleprofileAmmoJSONDecoder {

    enum VehicleprofileAmmoJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        var description: String {
            switch self {
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
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
