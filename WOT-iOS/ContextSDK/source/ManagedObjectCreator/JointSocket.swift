//
//  ManagedObjectLinkerSocket.swift
//  ContextSDK
//
//  Created by Paul on 11.01.23.
//

// MARK: - ManagedObjectLinkerSocket

public class JointSocket: NSObject, JointSocketProtocol {

    public var identifier: Any?
    public var keypath: KeypathType?

    override public var description: String {
        let kp = (keypath as? String) ?? "<NULL>"
        let id = String(describing: identifier, orValue: "<NULL>")
        return "<\(type(of: self)): keypath: \(kp), identifier: \(id)>"
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
