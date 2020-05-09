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

    init(masterFetchResult: FetchResult?, mappedObjectIdentifier: Any?, coreDataStore: WOTCoredataStoreProtocol?)
    func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion)
    func onJSONExtraction(json: JSON) -> JSON
}

public enum JSONAdapterLinkerError: Error {
    case wrongParentClass
    case wrongChildClass
}

public struct UnexpectedClassError: Error {
    var expected: AnyClass
    var received: AnyObject?
    public init(extected exp: AnyClass, received rec: AnyObject?) {
        self.expected = exp
        self.received = rec
    }
}

open class BaseJSONAdapterLinker: JSONAdapterLinkerProtocol {
    // MARK: - Open
    open var primaryKeyType: PrimaryKeyType { return .none }

    // MARK: - Public
    public var masterFetchResult: FetchResult?
    public var mappedObjectIdentifier: Any?
    public var coreDataStore: WOTCoredataStoreProtocol?

    public required init(masterFetchResult: FetchResult?, mappedObjectIdentifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
        self.masterFetchResult = masterFetchResult
        self.mappedObjectIdentifier = mappedObjectIdentifier
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

extension BaseJSONAdapterLinker: LogMessageSender {
    public var logSenderDescription: String {
        return String(describing: self)
    }
}
