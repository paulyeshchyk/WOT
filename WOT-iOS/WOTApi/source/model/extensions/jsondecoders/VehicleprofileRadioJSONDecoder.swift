//
//  VehicleprofileRadioJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

class VehicleprofileRadioJSONDecoder: JSONDecoderProtocol {

    var managedObject: (VehicleprofileRadio & DecodableProtocol & ManagedObjectProtocol)?

    func decode(using map: JSONMapProtocol, appContext _: (DataStoreContainerProtocol & LogInspectorContainerProtocol & RequestManagerContainerProtocol)?, forDepthLevel _: DecodingDepthLevel?) throws {
        guard let managedObject = managedObject else {
            return
        }
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject.decode(decoderContainer: element)
        //
    }
}
