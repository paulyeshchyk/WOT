//
//  VehicleprofileAmmoPenetration+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoPenetration {

    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONMapProtocol, managedObjectContextContainer _: ManagedObjectContextContainerProtocol, appContext _: JSONDecodableProtocol.Context?) throws {
        ///
        let array = try map.data(ofType: [Double].self)
        //
        guard array?.count == 3 else {
            throw VehicleprofileAmmoPenetrationError.arrayIsNotContainingThreeElements
        }
        let intArray = try NSDecimalNumberArray(array: array)
        min_value = intArray[0]
        avg_value = intArray[1]
        max_value = intArray[2]
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
