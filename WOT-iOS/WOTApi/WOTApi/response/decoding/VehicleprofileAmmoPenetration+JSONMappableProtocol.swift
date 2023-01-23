//
//  VehicleprofileAmmoPenetration+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoPenetration {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, appContext _: JSONDecodableProtocol.Context) throws {
        guard let penetrationJSON = map.jsonCollection.data() as? [Any] else {
            throw VehicleprofileAmmoPenetrationError.arrayIsExpected(map.jsonCollection)
        }
        //
        guard penetrationJSON.count == 3 else {
            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements(penetrationJSON)
        }
        let intArray = NSDecimalNumberArray(array: penetrationJSON)
        min_value = intArray.elements[0]
        avg_value = intArray.elements[1]
        max_value = intArray.elements[2]
    }
}

private enum VehicleprofileAmmoPenetrationError: Error, CustomStringConvertible {
    case arrayIsExpected(Any)
    case arrayIsNotContainingThreeElements([Any])
    var description: String {
        switch self {
        case .arrayIsExpected(let object): return "[\(type(of: self))]: Array is expected, but \(type(of: object))"
        case .arrayIsNotContainingThreeElements(let array): return "[\(type(of: self))]: Array is not containing 3 elements, but \(array.count)"
        }
    }
}
