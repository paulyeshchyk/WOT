//
//  ObjCManagedObjectCreatorProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias ManagedObjectCreatorContext = DataStoreContainerProtocol

@objc
public protocol ManagedObjectCreatorProtocol: MD5Protocol {
    var linkerPrimaryKeyType: PrimaryKeyType { get }

    init(masterFetchResult: FetchResultProtocol?, mappedObjectIdentifier: Any?)
    func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion)
    func onJSONExtraction(json: JSON) -> JSON?
}
