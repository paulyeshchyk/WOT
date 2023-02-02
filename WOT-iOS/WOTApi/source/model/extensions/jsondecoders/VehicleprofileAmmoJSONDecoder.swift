//
//  VehicleprofileAmmoJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoJSONDecoder

class VehicleprofileAmmoJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context
    var jsonMap: JSONMapProtocol?
    var decodingDepthLevel: DecodingDepthLevel?

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode() throws {
        guard let map = jsonMap else {
            throw VehicleprofileAmmoJSONDecoderErrors.jsonMapNotDefined
        }
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

        fetch_element(keypath: #keyPath(VehicleprofileAmmo.penetration),
                      parentKey: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo),
                      modelClass: VehicleprofileAmmoPenetration.self,
                      element: element,
                      contextPredicate: map.contextPredicate,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Damage

        fetch_element(keypath: #keyPath(VehicleprofileAmmo.damage),
                      parentKey: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo),
                      modelClass: VehicleprofileAmmoDamage.self,
                      element: element,
                      contextPredicate: map.contextPredicate,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
    }

    private func fetch_element(keypath: AnyHashable, parentKey: String, modelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let element = element[keypath] else {
                throw VehicleprofileAmmoJSONDecoderErrors.elementNotFound(keypath)
            }
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileAmmoError.invalidManagedRef
            }

            let composerInput = ComposerInput()
            composerInput.pin = JointPin(modelClass: modelClass, identifier: nil, contextPredicate: contextPredicate)
            composerInput.parentKey = parentKey
            let composer = VehicleprofileAmmo_Composer()
            let contextPredicate = try composer.build(composerInput)

            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)
            let jsonMap = try JSONMap(data: element, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }
}

// MARK: - %t + VehicleprofileAmmoJSONDecoder.VehicleprofileAmmoJSONDecoderErrors

extension VehicleprofileAmmoJSONDecoder {

    enum VehicleprofileAmmoJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)
        case elementNotFound(AnyHashable)
        case jsonMapNotDefined

        var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            case .elementNotFound(let keypath): return "[\(type(of: self))]: Element not found for (\(keypath))"
            }
        }
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
