//
//  VehicleprofileEngineJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileEngineJSONDecoder

class VehicleprofileEngineJSONDecoder: JSONDecoderProtocol {

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
            throw VehicleprofileEngineJSONDecoderError.jsonMapNotDefined
        }
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        //
    }
}

// MARK: - %t + VehicleprofileEngineJSONDecoder.VehicleprofileEngineJSONDecoderError

extension VehicleprofileEngineJSONDecoder {
    enum VehicleprofileEngineJSONDecoderError: Error, CustomStringConvertible {
        case jsonMapNotDefined

        var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            }
        }
    }
}
