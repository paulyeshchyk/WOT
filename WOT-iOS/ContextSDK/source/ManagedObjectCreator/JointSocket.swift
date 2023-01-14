//
//  ManagedObjectLinkerSocket.swift
//  ContextSDK
//
//  Created by Paul on 11.01.23.
//

// MARK: - ManagedObjectLinkerSocket

public class JointSocket: NSObject, JointSocketProtocol {

    public var managedRef: ManagedRefProtocol?
    public var identifier: Any?
    public var keypath: KeypathType?

    override public var description: String {
        let kp = (keypath as? String) ?? "<NULL>"
        let id = String(describing: identifier, orValue: "<NULL>")
        return "<\(type(of: self)): keypath: \(kp), identifier: \(id)>"
    }

    // MARK: Lifecycle

    public required init(managedRef: ManagedRefProtocol?, identifier: Any?, keypath: KeypathType?) {
        self.identifier = identifier
        self.keypath = keypath
        self.managedRef = managedRef
        super.init()
    }

    public convenience init(managedRef: ManagedRefProtocol?, identifier: Any?) {
        self.init(managedRef: managedRef, identifier: identifier, keypath: nil)
    }

    public convenience init(managedRef: ManagedRefProtocol?, keypath: KeypathType) {
        self.init(managedRef: managedRef, identifier: nil, keypath: keypath)
    }
}
