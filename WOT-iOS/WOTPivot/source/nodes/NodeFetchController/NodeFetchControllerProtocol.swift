//
//  NodeFetchControllerProtocol.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK

@objc
public protocol NodeFetchControllerProtocol {
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol

    func performFetch(nodeCreator: NodeCreatorProtocol?, appContext: Context) throws
    func fetchedNodes(byPredicates: [NSPredicate], nodeCreator: NodeCreatorProtocol?, filteredCompletion: FilteredObjectCompletion)
    func fetchedObjects() -> [AnyObject]?
    func setFetchListener(_ listener: NodeFetchControllerListenerProtocol?)
}

@objc
public protocol NodeFetchControllerListenerProtocol {
    func fetchPerformed(by: NodeFetchControllerProtocol)
    func fetchFailed(by: NodeFetchControllerProtocol, withError: Error)
}
