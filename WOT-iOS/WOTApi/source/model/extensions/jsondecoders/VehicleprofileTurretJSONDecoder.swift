//
//  VehicleprofileTurretJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

class VehicleprofileTurretJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel _: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        //
    }
}
