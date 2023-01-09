//
//  VehicleprofileArmorListHullManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileArmorListHullManagedObjectCreator: ManagedObjectExtractable {

    public var linkerPrimaryKeyType: PrimaryKeyType {
        return .external
    }

    public var jsonKeyPath: KeypathType? {
        nil
    }
}
