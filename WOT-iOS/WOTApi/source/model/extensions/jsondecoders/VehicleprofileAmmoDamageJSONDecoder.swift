//
//  VehicleprofileAmmoDamageJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoDamageJSONDecoder

class VehicleprofileAmmoDamageJSONDecoder: JSONDecoderProtocol {

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
            throw VehicleprofileAmmoDamageJSONDecoderErrors.jsonMapNotDefined
        }
        //
        let array = try map.data(ofType: [Double].self)
        let ammoDamage = try MinAvgMax(array)
        try managedObject?.decode(decoderContainer: ammoDamage)
        //
    }
}

// MARK: - %t + VehicleprofileAmmoDamageJSONDecoder.VehicleprofileAmmoDamageJSONDecoderErrors

extension VehicleprofileAmmoDamageJSONDecoder {

    enum VehicleprofileAmmoDamageJSONDecoderErrors: Error, CustomStringConvertible {
        case arrayIsNotContainingThreeElements
        case jsonMapNotDefined

        var description: String {
            switch self {
            case .jsonMapNotDefined: return "[\(type(of: self))]: JSONMap is not defined"
            case .arrayIsNotContainingThreeElements: return "[\(type(of: self))]: Dublicate"
            }
        }
    }
}
