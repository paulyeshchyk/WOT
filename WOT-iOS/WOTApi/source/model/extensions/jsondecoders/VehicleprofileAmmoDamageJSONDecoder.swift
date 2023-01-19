//
//  VehicleprofileAmmoDamageJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoDamageJSONDecoder

class VehicleprofileAmmoDamageJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: Context?

    required init(appContext: Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, forDepthLevel _: DecodingDepthLevel?) throws {
        //
        let array = try map.data(ofType: [Double].self)
        let ammoDamage = try MinAvgMax(array)
        try managedObject?.decode(decoderContainer: ammoDamage)
        //
    }
}

// MARK: - VehicleprofileAmmoDamageError

private enum VehicleprofileAmmoDamageError: Error, CustomStringConvertible {
    case arrayIsNotContainingThreeElements

    var description: String {
        switch self {
        case .arrayIsNotContainingThreeElements: return "[\(type(of: self))]: Dublicate"
        }
    }
}
