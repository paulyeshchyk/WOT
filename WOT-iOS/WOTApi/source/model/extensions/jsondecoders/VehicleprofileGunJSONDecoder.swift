//
//  VehicleprofileGunJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

class VehicleprofileGunJSONDecoder: JSONDecoderProtocol {

    var managedObject: (VehicleprofileGun & DecodableProtocol & ManagedObjectProtocol)?

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
