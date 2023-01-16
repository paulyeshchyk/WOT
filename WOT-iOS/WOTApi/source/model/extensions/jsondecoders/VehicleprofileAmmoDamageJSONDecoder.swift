//
//  VehicleprofileAmmoDamageJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileAmmoDamageJSONDecoder

class VehicleprofileAmmoDamageJSONDecoder: JSONDecoderProtocol {

    var managedObject: (VehicleprofileAmmoDamage & DecodableProtocol & ManagedObjectProtocol)?

    func decode(using map: JSONMapProtocol, appContext _: (DataStoreContainerProtocol & LogInspectorContainerProtocol & RequestManagerContainerProtocol)?, forDepthLevel _: DecodingDepthLevel?) throws {
        guard let managedObject = managedObject else {
            return
        }
        ///
        let array = try map.data(ofType: [Double].self)
        //
        guard array?.count == 3 else {
            throw VehicleprofileAmmoDamageError.arrayIsNotContainingThreeElements
        }
        let intArray = try NSDecimalNumberArray(array: array)
        managedObject.min_value = intArray.elements[0]
        managedObject.avg_value = intArray.elements[1]
        managedObject.max_value = intArray.elements[2]
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
