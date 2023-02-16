//
//  VehicleprofileArmorList+Extractor.swift
//  WOTApi
//
//  Created by Paul on 2.02.23.
//

extension VehicleprofileArmorList {

    private class HullExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }

    private class TurretExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }
}
