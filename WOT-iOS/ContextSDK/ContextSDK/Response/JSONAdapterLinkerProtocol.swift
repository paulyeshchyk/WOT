//
//  JSONAdapterLinkerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public protocol JSONAdapterLinkerProtocol {
    var linkerPrimaryKeyType: PrimaryKeyType { get }

    init(masterFetchResult: FetchResultProtocol?, mappedObjectIdentifier: Any?)
    func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion)
    func onJSONExtraction(json: JSON) -> JSON
}