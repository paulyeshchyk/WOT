//
//  VehicleprofileAmmoList+Extractor.swift
//  WOTApi
//
//  Created by Paul on 2.02.23.
//

// MARK: - VehicleprofileAmmoList.AmmoExtractor

extension VehicleprofileAmmoList {

    class AmmoExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }
}
