//
//  VehiclesTreeManagedObjectExtractor.swift
//  WOTApi
//
//  Created by Paul on 9.01.23.
//

public class VehiclesTreeManagedObjectExtractor: ManagedObjectExtractable {

    public var linkerPrimaryKeyType: PrimaryKeyType {
        return .internal
    }

    // MARK: Public

    public func extractJSON(from: JSON) -> JSON? {
        return from
    }
}
