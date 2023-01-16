//
//  VehicleprofileAmmoPenetrationJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoPenetrationJSONDecoder

class VehicleprofileAmmoPenetrationJSONDecoder: JSONDecoderProtocol {
    private let appContext: JSONDecoderProtocol.Context?
    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using _: JSONMapProtocol, appContext _: JSONDecoderProtocol.Context?, forDepthLevel _: DecodingDepthLevel?) throws {
//        let array = try map.data(ofType: [Double].self)
//        //
//        guard array?.count == 3 else {
//            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements
//        }
//        managedObject.min_value = array?[0].asDecimal
//        managedObject.avg_value = array?[1].asDecimal
//        managedObject.max_value = array?[2].asDecimal
    }
}

// MARK: - VehicleprofileAmmoPenetrationError

private enum VehicleprofileAmmoPenetrationError: Error, CustomStringConvertible {
    case arrayIsExpected(Any)
    case arrayIsNotContainingThreeElements

    var description: String {
        switch self {
        case .arrayIsExpected(let object): return "[\(type(of: self))]: Array is expected, but \(type(of: object))"
        case .arrayIsNotContainingThreeElements: return "[\(type(of: self))]: Array is not containing 3 elements"
        }
    }
}
