//
//  VehicleprofileGunJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

class VehicleprofileGunJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: Context?

    required init(appContext: Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel _: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        //
    }
}
