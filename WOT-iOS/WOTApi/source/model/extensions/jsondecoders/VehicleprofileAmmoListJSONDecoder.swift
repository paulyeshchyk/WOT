//
//  VehicleprofileAmmoListJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoListJSONDecoder

class VehicleprofileAmmoListJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context
    var jsonMap: JSONMapProtocol?
    var decodingDepthLevel: DecodingDepthLevel?

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode() throws {
        guard let map = jsonMap else {
            throw VehicleprofileAmmoListJSONDecoderErrors.jsonMapNotDefined
        }

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.isMaxLevelReached ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoListJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        //
        let profilesJSON = try map.data(ofType: [JSON].self)

        //
        profilesJSON.forEach { jsonElement in

            fetch_element(keypath: #keyPath(VehicleprofileAmmo.type),
                          parentKey: #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList),
                          modelClass: VehicleprofileAmmo.self,
                          element: jsonElement,
                          contextPredicate: map.contextPredicate,
                          decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
        }
    }

    func fetch_element(keypath: AnyHashable, parentKey: String, modelClass: ModelClassType, element: JSON, contextPredicate: ContextPredicateProtocol, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileAmmoListJSONDecoderErrors.managedRefNotFound
            }

            guard let module_id = element[keypath] else {
                throw VehicleprofileAmmoListJSONDecoderErrors.idNotFound(keypath)
            }

            let composerInput = ComposerInput()
            composerInput.pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: contextPredicate)
            composerInput.parentKey = parentKey
            let composer = VehicleprofileAmmoList_Composer()
            let contextPredicate = try composer.build(composerInput)

            let socket = JointSocket(managedRef: managedRef, identifier: nil/* ammoType */)
            let jsonMap = try JSONMap(data: element, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}

// MARK: - %t + VehicleprofileAmmoListJSONDecoder.VehicleprofileAmmoListJSONDecoderErrors

extension VehicleprofileAmmoListJSONDecoder {

    enum VehicleprofileAmmoListJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)
        case idNotFound(AnyHashable)
        case managedRefNotFound
        case jsonMapNotDefined

        public var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            case .idNotFound(let keypath): return "[\(type(of: self))]: id not found for (\(keypath))"
            case .managedRefNotFound: return "[\(type(of: self))]: managedRef not found"
            }
        }
    }
}
