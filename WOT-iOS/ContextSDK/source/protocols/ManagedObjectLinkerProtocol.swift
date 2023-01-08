//
//  ManagedObjectLinkerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

public typealias ManagedObjectLinkerContext = DataStoreContainerProtocol
public typealias KeypathType = AnyHashable

// MARK: - ManagedObjectLinkerAnchorProtocol

@objc
public protocol ManagedObjectLinkerAnchorProtocol {
    var identifier: Any? { get }
    var keypath: KeypathType? { get }
    init(identifier: Any?, keypath: KeypathType?)
}

// MARK: - ManagedObjectLinkerAnchor

public class ManagedObjectLinkerAnchor: NSObject, ManagedObjectLinkerAnchorProtocol {

    public var identifier: Any?
    public var keypath: KeypathType?

    override public var description: String {
        let kp: String
        if let kpath = (keypath as? String) {
            kp = kpath
        } else {
            kp = "<NULL>"
        }
        let id: String
        if let identifier = identifier {
            id = String(describing: identifier)
        } else {
            id = "<NULL>"
        }
        return "\(type(of: self)): keypath [\(kp)]; identifier [\(id)]"
    }

    // MARK: Lifecycle

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

public typealias ManagedObjectLinkerCompletion = (FetchResultProtocol, Error?) -> Void

// MARK: - ManagedObjectLinkerProtocol

@objc
public protocol ManagedObjectLinkerProtocol: MD5Protocol {
    init(modelClass: PrimaryKeypathProtocol.Type, masterFetchResult: FetchResultProtocol?, anchor: ManagedObjectLinkerAnchorProtocol)
    func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerContext?, completion: @escaping ManagedObjectLinkerCompletion)
}
