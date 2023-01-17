//
//  VehicleprofileAmmoListJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoListJSONDecoder

class VehicleprofileAmmoListJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel: DecodingDepthLevel?) throws {
        //
        let profilesJSON = try map.data(ofType: [JSON].self)

        //
        let keypath = #keyPath(VehicleprofileAmmo.type)
        try profilesJSON?.forEach { jsonElement in
            let foreignSelectKey = #keyPath(VehicleprofileAmmo.vehicleprofileAmmoList)
            let ammoType = jsonElement[keypath]
            let modelClass = VehicleprofileAmmo.self
            let pin = JointPin(modelClass: modelClass, identifier: ammoType, contextPredicate: map.contextPredicate)
            let composer = VehicleprofileAmmoListAmmoRequestPredicateComposer(pin: pin, foreignSelectKey: foreignSelectKey)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(data: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    self.appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
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
