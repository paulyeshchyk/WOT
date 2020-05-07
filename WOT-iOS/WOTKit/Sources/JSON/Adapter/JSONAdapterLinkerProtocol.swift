//
//  JSONAdapterLinkerProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

@objc
public protocol JSONAdapterLinkerProtocol {
    var primaryKeyType: PrimaryKeyType { get }

    init(masterFetchResult: FetchResult?, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?)
    func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion)
    func onJSONExtraction(json: JSON) -> JSON
}

public enum JSONAdapterLinkerError: Error {
    case wrongParentClass
    case wrongChildClass
}

open class BaseJSONAdapterLinker: JSONAdapterLinkerProtocol {
    // MARK: - Open
    open var primaryKeyType: PrimaryKeyType { return .none }

    // MARK: - Public
    public var masterFetchResult: FetchResult?
    public var identifier: Any?
    public var coreDataStore: WOTCoredataStoreProtocol?

    public required init(masterFetchResult: FetchResult?, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
        self.masterFetchResult = masterFetchResult
        self.identifier = identifier
        self.coreDataStore = coreDataStore
    }

    open func onJSONExtraction(json: JSON) -> JSON {
        fatalError("\(type(of: self))::\(#function)")
        //throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    open func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
        fatalError("\(type(of: self))::\(#function)")
        //throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}
