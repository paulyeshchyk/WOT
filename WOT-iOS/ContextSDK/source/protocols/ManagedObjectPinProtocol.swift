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
    func doLinking(_ element: ManagedObjectPinProtocol, socket: JointSocketProtocol)
    func doLinking(_ elements: [ManagedObjectPinProtocol], socket: JointSocketProtocol)
}

// MARK: - NSSet + ManagedObjectSocketProtocol

extension NSSet: ManagedObjectSocketProtocol {
    public func doLinking(_ element: ManagedObjectPinProtocol, socket: JointSocketProtocol) {
        compactMap { $0 as? ManagedObjectSocketProtocol }
            .forEach {
                $0.doLinking(element, socket: socket)
            }
    }

    public func doLinking(_ array: [ManagedObjectPinProtocol], socket: JointSocketProtocol) {
        compactMap { $0 as? ManagedObjectSocketProtocol }
            .forEach {
                $0.doLinking(array, socket: socket)
            }
    }
}
