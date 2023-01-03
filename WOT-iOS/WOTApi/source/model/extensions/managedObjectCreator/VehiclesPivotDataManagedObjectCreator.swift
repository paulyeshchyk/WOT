//
//  VehiclesPivotDataManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

import WOTKit

public class VehiclesPivotManagedObjectExtractor: ManagedObjectExtractable {
    public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    public func extractJSON(from: JSON) -> JSON? {
        return from
    }
}

public class VehiclesPivotDataManagedObjectCreator: ManagedObjectLinker {
    public typealias Context = DataStoreContainerProtocol

    public convenience init(modelClass: PrimaryKeypathProtocol.Type, appContext: Context) throws {
        let inManagedObjectContext = appContext.dataStore?.workingContext()
        let emptyFetchResult = try EmptyFetchResult(inManagedObjectContext: inManagedObjectContext)
        let anchor = ManagedObjectLinkerAnchor(identifier: nil, keypath: nil)
        self.init(modelClass: modelClass, masterFetchResult: emptyFetchResult, anchor: anchor)
    }

    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func extractJSON(from: JSON) -> JSON? {
        return from
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerContext, completion: @escaping FetchResultCompletion) {
        // MARK: stash

        appContext.dataStore?.stash(managedObjectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
