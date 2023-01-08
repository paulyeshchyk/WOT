//
//  VehiclesTreeManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

import WOTKit

// MARK: - VehiclesTreeManagedObjectExtractor

public class VehiclesTreeManagedObjectExtractor: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

    // MARK: Public

    public func extractJSON(from: JSON) -> JSON? {
        return from
    }
}

// MARK: - VehiclesTreeManagedObjectCreator

public class VehiclesTreeManagedObjectCreator: ManagedObjectLinker {

    public typealias Context = DataStoreContainerProtocol

    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }

    // MARK: Lifecycle

    public convenience init(modelClass: PrimaryKeypathProtocol.Type, appContext: Context) throws {
        let emptyFetchResult = try appContext.dataStore?.emptyFetchResult()
        let anchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: nil)
        self.init(modelClass: modelClass, masterFetchResult: emptyFetchResult, anchor: anchor)
    }

    // MARK: Public

    override public func extractJSON(from: JSON) -> JSON? {
        return from
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerContext?, completion: @escaping ManagedObjectLinkerCompletion) {
        // MARK: stash

        appContext?.dataStore?.stash(managedObjectContext: fetchResult.managedObjectContext) { _, error in
            completion(fetchResult, error)
        }
    }
}
