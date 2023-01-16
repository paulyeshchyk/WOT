//
//  VehicleprofileAmmoDamage+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoDamage {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, appContext _: JSONDecodableProtocol.Context?, forDepthLevel _: DecodingDepthLevel?) throws {
        ///
        let array = try map.data(ofType: [Double].self)
        //
        guard array?.count == 3 else {
            throw VehicleprofileAmmoDamageError.arrayIsNotContainingThreeElements
        }
        let intArray = try NSDecimalNumberArray(array: array)
        min_value = intArray.elements[0]
        avg_value = intArray.elements[1]
        max_value = intArray.elements[2]
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
