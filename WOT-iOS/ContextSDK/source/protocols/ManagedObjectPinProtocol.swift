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

// MARK: - ManagedObjectSocketProtocol

public protocol ManagedObjectSocketProtocol {
    func doLinking(pin element: ManagedObjectPinProtocol, socket: JointSocketProtocol)
    func doLinking(pins elements: [ManagedObjectPinProtocol], socket: JointSocketProtocol)
}

// MARK: - NSSet + ManagedObjectSocketProtocol

extension NSSet: ManagedObjectSocketProtocol {
    public func doLinking(pin element: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        compactMap { $0 as? ManagedObjectSocketProtocol }
            .forEach {
                $0.doLinking(pin: element, socket: socket)
            }
    }

    public func doLinking(pins array: [ManagedObjectPinProtocol], socket: JointSocketProtocol) {
        compactMap { $0 as? ManagedObjectSocketProtocol }
            .forEach {
                $0.doLinking(pins: array, socket: socket)
            }
    }
}
