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
    var linkerPrimaryKeyType: PrimaryKeyType { get }

    init(masterFetchResult: FetchResult?, mappedObjectIdentifier: Any?)
    func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion)
    func onJSONExtraction(json: JSON) -> JSON
}

public enum BaseJSONAdapterLinkerError: Error, CustomDebugStringConvertible {
    case unexpectedClass(AnyClass)
    public var debugDescription: String {
        switch self {
        case .unexpectedClass(let clazz): return "Class is not supported; expected class is:[\(String(describing: clazz))]"
        }
    }
}

open class BaseJSONAdapterLinker: JSONAdapterLinkerProtocol {
    // MARK: - Open

    open var linkerPrimaryKeyType: PrimaryKeyType {
        fatalError("should be overriden")
    }

    // MARK: - Public

    public var masterFetchResult: FetchResult?
    public var mappedObjectIdentifier: Any?

    public required init(masterFetchResult: FetchResult?, mappedObjectIdentifier: Any?) {
        self.masterFetchResult = masterFetchResult
        self.mappedObjectIdentifier = mappedObjectIdentifier
    }

    open func onJSONExtraction(json: JSON) -> JSON {
        fatalError("\(type(of: self))::\(#function)")
        // throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    open func process(fetchResult: FetchResult, coreDataStore: WOTCoredataStoreProtocol?, completion: @escaping FetchResultErrorCompletion) {
        fatalError("\(type(of: self))::\(#function)")
        // throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }
}
