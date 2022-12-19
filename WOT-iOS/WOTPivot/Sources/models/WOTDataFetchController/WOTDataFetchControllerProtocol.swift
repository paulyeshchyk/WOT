//
//  WOTDataFetchControllerProtocol.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

@objc
public protocol WOTDataFetchControllerProtocol {
    func performFetch(nodeCreator: WOTNodeCreatorProtocol?) throws
    func fetchedNodes(byPredicates: [NSPredicate], nodeCreator: WOTNodeCreatorProtocol?, filteredCompletion: FilteredObjectCompletion)
    func fetchedObjects() -> [AnyObject]?
    func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?)
}

@objc
public protocol WOTDataFetchControllerListenerProtocol {
    func fetchPerformed(by: WOTDataFetchControllerProtocol)
    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error)
}
