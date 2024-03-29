//
//  VehicleprofileArmorListJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileArmorListJSONDecoder

class VehicleprofileArmorListJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    var jsonMap: JSONMapProtocol?
    var decodingDepthLevel: DecodingDepthLevel?
    var inContextOfWork: UOWProtocol?

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode() throws {
        guard let map = jsonMap else {
            throw VehicleprofileArmorListJSONDecoderErrors.jsonMapNotDefined
        }

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.isMaxLevelReached ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileArmorListJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        //
        let element = try map.data(ofType: JSON.self)

        // MARK: - turret

        fetch_element(keypath: #keyPath(VehicleprofileArmorList.turret),
                      parentKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListTurret),
                      modelClass: VehicleprofileArmor.self,
                      element: element,
                      contextPredicate: map.contextPredicate,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - hull

        fetch_element(keypath: #keyPath(VehicleprofileArmorList.hull),
                      parentKey: #keyPath(VehicleprofileArmor.vehicleprofileArmorListHull),
                      modelClass: VehicleprofileArmor.self,
                      element: element,
                      contextPredicate: map.contextPredicate,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
    }

    private func fetch_element(keypath: AnyHashable, parentKey: String, modelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let jsonElement = element[keypath] as? JSON else {
                throw VehicleprofileArmorListJSONDecoderErrors.elementNotFound(keypath)
            }
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileArmorListJSONDecoderErrors.managedRefNotFound
            }

            let composerInput = ComposerInput()
            composerInput.contextPredicate = contextPredicate
            composerInput.parentKey = parentKey
            composerInput.parentJSONRefs = []
            let composer = ForeignKey_Composer()
            let contextPredicate = try composer.build(composerInput)

            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)

            let jsonMap = try JSONMap(data: jsonElement, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel

            appContext.uowManager.run(unit: uow, inContextOfWork: inContextOfWork, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }
}

// MARK: - %t + VehicleprofileArmorListJSONDecoder.VehicleprofileArmorListJSONDecoderErrors

extension VehicleprofileArmorListJSONDecoder {

    enum VehicleprofileArmorListJSONDecoderErrors: Error, CustomStringConvertible {
        case hullNotFound
        case turretNotFound
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)
        case elementNotFound(AnyHashable)
        case managedRefNotFound
        case jsonMapNotDefined

        var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            case .turretNotFound: return "[\(type(of: self))]: Turret not found"
            case .hullNotFound: return "[\(type(of: self))]: Hull not found"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            case .elementNotFound(let keypath): return "[\(type(of: self))]: Element not found for (\(keypath))"
            case .managedRefNotFound: return "[\(type(of: self))]: ManagedRef not found"
            }
        }
    }
}
