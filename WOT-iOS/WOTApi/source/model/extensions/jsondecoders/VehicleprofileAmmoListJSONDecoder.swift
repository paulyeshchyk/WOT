//
//  VehicleprofileAmmoListJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoListJSONDecoder

class VehicleprofileAmmoListJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileAmmoListJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        //
        let profilesJSON = try map.data(ofType: [JSON].self)

        //
        let keypath = #keyPath(VehicleprofileAmmo.type)
        try profilesJSON.forEach { jsonElement in
            let ammoType = jsonElement[keypath]
            let modelClass = VehicleprofileAmmo.self

            let composerInput = ComposerInput()
            composerInput.pin = JointPin(modelClass: modelClass, identifier: ammoType, contextPredicate: map.contextPredicate)
            composerInput.parentKey = #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList)
            let composer = VehicleprofileAmmoList_Composer()
            let contextPredicate = try composer.build(composerInput)

            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: nil/* ammoType */)
            let jsonMap = try JSONMap(data: jsonElement, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
        }
    }
}

// MARK: - %t + VehicleprofileAmmoListJSONDecoder.VehicleprofileAmmoListJSONDecoderErrors

extension VehicleprofileAmmoListJSONDecoder {

    enum VehicleprofileAmmoListJSONDecoderErrors: Error, CustomStringConvertible {
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
        }
    }
}

// MARK: - VehicleprofileAmmoList.AmmoExtractor

extension VehicleprofileAmmoList {

    private class AmmoExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }
}
