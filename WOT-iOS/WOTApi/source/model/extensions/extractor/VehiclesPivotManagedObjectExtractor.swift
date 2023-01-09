//
//  VehiclesPivotManagedObjectExtractor.swift
//  WOTApi
//
//  Created by Paul on 9.01.23.
//

public class VehiclesPivotManagedObjectExtractor: ManagedObjectExtractable {

    public var linkerPrimaryKeyType: PrimaryKeyType {
        return .internal
    }

    public var jsonKeyPath: KeypathType? {
        nil
    }
}
