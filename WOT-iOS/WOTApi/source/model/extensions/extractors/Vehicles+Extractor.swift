//
//  Vehicles+Extractor.swift
//  WOTApi
//
//  Created by Paul on 2.02.23.
//

extension Vehicles {

    class DefaultProfileExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }

    class ModulesTreeExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }

    class PivotViewManagedObjectExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }

    class TreeViewManagedObjectExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
        public var jsonKeyPath: KeypathType? { nil }
        public required init() {}
    }
}
