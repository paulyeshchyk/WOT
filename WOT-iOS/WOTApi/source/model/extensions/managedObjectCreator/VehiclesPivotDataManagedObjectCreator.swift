//
//  VehiclesPivotDataManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

import WOTKit

public class VehiclesPivotDataManagedObjectCreator: ManagedObjectCreator {
    public typealias Context = DataStoreContainerProtocol

    public convenience init(appContext: Context) throws {
        let inManagedObjectContext = appContext.dataStore?.workingContext()
        let emptyFetchResult = try EmptyFetchResult(inManagedObjectContext: inManagedObjectContext)
        self.init(masterFetchResult: emptyFetchResult, mappedObjectIdentifier: nil)
    }

    override public var linkerPrimaryKeyType: PrimaryKeyType { return .internal }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        // MARK: stash

        appContext.dataStore?.stash(managedObjectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}
