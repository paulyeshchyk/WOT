//
//  WOTDataFetchControllerProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

@objc
public protocol WOTDataFetchControllerProtocol {
    func performFetch()
    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol]
    func fetchedObjects() -> [AnyObject]?
    func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?)
}

@objc
public protocol WOTDataFetchControllerListenerProtocol {
    func fetchPerformed(by: WOTDataFetchControllerProtocol)
    func fetchFailed(by: WOTDataFetchControllerProtocol, withError: Error)
}

@objc
public protocol WOTDataFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}
