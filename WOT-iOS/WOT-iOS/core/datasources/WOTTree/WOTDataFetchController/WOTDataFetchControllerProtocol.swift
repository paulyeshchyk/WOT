//
//  WOTDataFetchControllerProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTDataFetchControllerProtocol {
    func performFetch() throws
    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol]
    func fetchedObjects() -> [AnyObject]?
    func setListener(_ listener: WOTDataFetchControllerListenerProtocol?)
}

@objc
protocol WOTDataFetchControllerListenerProtocol {
    func fetchPerformed(by: WOTDataFetchControllerProtocol)
    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error)
}

@objc
protocol WOTDataFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
    func createNode(fetchedObject: NSFetchRequestResult, byPredicate: NSPredicate) -> WOTNodeProtocol
}
