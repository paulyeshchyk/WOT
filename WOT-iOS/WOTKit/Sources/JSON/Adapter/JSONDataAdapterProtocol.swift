//
//  JSONAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol JSONAdapterProtocol: DataAdapterProtocol {
    var linker: JSONAdapterLinkerProtocol? { get set }
}

@objc
public protocol JSONAdapterLinkerProtocol {
    init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?)
    var primaryKeyType: PrimaryKeyType { get }
    func process(fetchResult: FetchResult)
    func onJSONExtraction(json: JSON) -> JSON?
}
