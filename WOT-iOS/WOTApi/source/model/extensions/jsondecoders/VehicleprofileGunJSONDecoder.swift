//
//  VehicleprofileGunJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileGunJSONDecoder

class VehicleprofileGunJSONDecoder: JSONDecoderProtocol {

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
            throw VehicleprofileGunJSONDecoderError.jsonMapNotDefined
        }
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        //
    }
}

// MARK: - %t + VehicleprofileGunJSONDecoder.VehicleprofileGunJSONDecoderError

extension VehicleprofileGunJSONDecoder {
    enum VehicleprofileGunJSONDecoderError: Error, CustomStringConvertible {
        case jsonMapNotDefined

        var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            }
        }
    }
}
