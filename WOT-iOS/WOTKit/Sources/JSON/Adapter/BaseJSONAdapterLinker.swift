//
//  JSONAdapterLinkerProtocol.swift
//  WOTKit
//
//  Created by Pavel Yeshchyk on 5/7/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public enum BaseJSONAdapterLinkerError: Error, CustomStringConvertible {
    case unexpectedClass(AnyClass)
    case noManagedObjectFound
    public var description: String {
        switch self {
        case .unexpectedClass(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(String(describing: clazz))]"
        case .noManagedObjectFound: return "[\(type(of: self))] No managed object found"
        }
    }
}

open class BaseJSONAdapterLinker: JSONAdapterLinkerProtocol {
    
    // MARK: - Open

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    open var linkerPrimaryKeyType: PrimaryKeyType {
        fatalError("should be overriden")
    }

    // MARK: - Public

    public var masterFetchResult: FetchResultProtocol?
    public var mappedObjectIdentifier: Any?

    public required init(masterFetchResult: FetchResultProtocol?, mappedObjectIdentifier: Any?) {
        self.masterFetchResult = masterFetchResult
        self.mappedObjectIdentifier = mappedObjectIdentifier
    }

    open func onJSONExtraction(json: JSON) -> JSON? { return nil }

    open func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        fatalError("\(type(of: self))::\(#function)")
    }
}
