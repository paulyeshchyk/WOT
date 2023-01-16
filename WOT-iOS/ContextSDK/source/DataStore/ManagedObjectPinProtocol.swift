//
//  ManagedObjectLinkable.swift
//  ContextSDK
//
//  Created by Paul on 2.01.23.
//

// MARK: - ManagedObjectPinProtocol

public protocol ManagedObjectPinProtocol {
    //
}

// MARK: - ManagedObjectPlugProtocol

public protocol ManagedObjectPlugProtocol {
    func plug(pin: ManagedObjectPinProtocol, intoSocket: JointSocketProtocol)
    func plug(pins: [ManagedObjectPinProtocol], intoSocket: JointSocketProtocol)
}

// MARK: - NSSet + ManagedObjectPlugProtocol

extension NSSet: ManagedObjectPlugProtocol {
    public func plug(pin: ManagedObjectPinProtocol, intoSocket: JointSocketProtocol) {
        compactMap { $0 as? ManagedObjectPlugProtocol }
            .forEach {
                $0.plug(pin: pin, intoSocket: intoSocket)
            }
    }

    public func plug(pins: [ManagedObjectPinProtocol], intoSocket: JointSocketProtocol) {
        compactMap { $0 as? ManagedObjectPlugProtocol }
            .forEach {
                $0.plug(pins: pins, intoSocket: intoSocket)
            }
    }
}
