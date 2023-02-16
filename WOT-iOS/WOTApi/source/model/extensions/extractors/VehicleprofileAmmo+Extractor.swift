//
//  VehicleprofileAmmo+Extractor.swift
//  WOTApi
//
//  Created by Paul on 2.02.23.
//

extension VehicleprofileAmmo {

    class DamageExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }

    class PenetrationExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }
}
