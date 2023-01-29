//
//  VehicleprofileAmmoPenetrationJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoPenetrationJSONDecoder

class VehicleprofileAmmoPenetrationJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel _: DecodingDepthLevel?) throws {
        //
        let array = try map.data(ofType: [Double].self)
        let ammoPenetration = try MinAvgMax(array)
        try managedObject?.decode(decoderContainer: ammoPenetration)
        //
    }
}

// MARK: - %t + VehicleprofileAmmoPenetrationJSONDecoder.VehicleprofileAmmoPenetrationJSONDecoderErrors

extension VehicleprofileAmmoPenetrationJSONDecoder {

    enum VehicleprofileAmmoPenetrationJSONDecoderErrors: Error, CustomStringConvertible {
        case arrayIsExpected(Any)
        case arrayIsNotContainingThreeElements

        var description: String {
            switch self {
            case .arrayIsExpected(let object): return "[\(type(of: self))]: Array is expected, but \(type(of: object))"
            case .arrayIsNotContainingThreeElements: return "[\(type(of: self))]: Array is not containing 3 elements"
            }
        }
    }
}
