//
//  VehicleprofileAmmoDamage+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public extension VehicleprofileAmmoDamage {
    // MARK: - JSONDecodableProtocol

    override func decode(using map: JSONCollectionContainerProtocol, managedObjectContextContainer _: ManagedObjectContextContainerProtocol, appContext _: JSONDecodableProtocol.Context) throws {
        guard let ammoDamageJSON = map.jsonCollection.data() as? [Any] else {
            throw JSONManagedObjectMapError.notAnArray(map)
        }
        //
        guard ammoDamageJSON.count == 3 else {
            throw VehicleprofileAmmoDamageError.arrayIsNotContainingThreeElements
        }
        let intArray = NSDecimalNumberArray(array: ammoDamageJSON)
        min_value = intArray.elements[0]
        avg_value = intArray.elements[1]
        max_value = intArray.elements[2]
    }
}

private enum VehicleprofileAmmoDamageError: Error, CustomStringConvertible {
    case arrayIsNotContainingThreeElements
    var description: String {
        switch self {
        case .arrayIsNotContainingThreeElements: return "[\(type(of: self))]: Dublicate"
        }
    }
}
