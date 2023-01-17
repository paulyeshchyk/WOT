//
//  VehicleprofileAmmoDamageJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoDamageJSONDecoder

class VehicleprofileAmmoDamageJSONDecoder: JSONDecoderProtocol {

    private weak var appContext: JSONDecoderProtocol.Context?

    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using _: JSONMapProtocol, forDepthLevel _: DecodingDepthLevel?) throws {
//        let array = try map.data(ofType: [Double].self)
        //
//        guard array?.count == 3 else {
//            throw VehicleprofileAmmoDamageError.arrayIsNotContainingThreeElements
//        }
//        managedObject.min_value = array?[0].asDecimal
//        managedObject.avg_value = array?[1].asDecimal
//        managedObject.max_value = array?[2].asDecimal
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
