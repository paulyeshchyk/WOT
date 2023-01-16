//
//  VehicleprofileAmmoPenetrationJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoPenetrationJSONDecoder

class VehicleprofileAmmoPenetrationJSONDecoder: JSONDecoderProtocol {

    var managedObject: (VehicleprofileAmmoPenetration & DecodableProtocol & ManagedObjectProtocol)?

    func decode(using map: JSONMapProtocol, appContext _: (DataStoreContainerProtocol & LogInspectorContainerProtocol & RequestManagerContainerProtocol)?, forDepthLevel _: DecodingDepthLevel?) throws {
        guard let managedObject = managedObject else {
            return
        }

        //
        let array = try map.data(ofType: [Double].self)
        //
        guard array?.count == 3 else {
            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements
        }
        let intArray = try NSDecimalNumberArray(array: array)
        managedObject.min_value = intArray[0]
        managedObject.avg_value = intArray[1]
        managedObject.max_value = intArray[2]
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
