//
//  ManagedObjectLinkerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias ManagedObjectLinkerContext = DataStoreContainerProtocol
public typealias KeypathType = AnyHashable

@objc
public protocol ManagedObjectLinkerAnchorProtocol {
    var identifier: Any? { get }
    var keypath: KeypathType? { get }
    init(identifier: Any?, keypath: KeypathType?)
}

public class ManagedObjectLinkerAnchor: NSObject, ManagedObjectLinkerAnchorProtocol {
    public var identifier: Any?
    public var keypath: KeypathType?

    public required init(identifier: Any?, keypath: KeypathType?) {
        self.identifier = identifier
        self.keypath = keypath
        super.init()
    }

    override public convenience init() {
        self.init(identifier: nil, keypath: nil)
    }

    public convenience init(identifier: Any?) {
        self.init(identifier: identifier, keypath: nil)
    }

    public convenience init(keypath: KeypathType) {
        self.init(identifier: nil, keypath: keypath)
    }
}

@objc
public protocol ManagedObjectLinkerProtocol: MD5Protocol {
    init(modelClass: PrimaryKeypathProtocol.Type, masterFetchResult: FetchResultProtocol?, anchor: ManagedObjectLinkerAnchorProtocol)
    func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerContext, completion: @escaping FetchResultCompletion)
}
