//
//  ManagedObjectLinkable.swift
//  ContextSDK
//
//  Created by Paul on 2.01.23.
//

// MARK: - ManagedObjectLinkable

public protocol ManagedObjectLinkable {
    //
}

// MARK: - ManagedObjectLinkHostable

public protocol ManagedObjectLinkHostable {
    func doLinking(_ element: ManagedObjectLinkable, socket: ManagedObjectLinkerSocketProtocol)
    func doLinking(_ elements: [ManagedObjectLinkable], socket: ManagedObjectLinkerSocketProtocol)
}

// MARK: - NSSet + ManagedObjectLinkHostable

extension NSSet: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, socket: ManagedObjectLinkerSocketProtocol) {
        compactMap { $0 as? ManagedObjectLinkHostable }
            .forEach {
                $0.doLinking(element, socket: socket)
            }
    }

    public func doLinking(_ array: [ManagedObjectLinkable], socket: ManagedObjectLinkerSocketProtocol) {
        compactMap { $0 as? ManagedObjectLinkHostable }
            .forEach {
                $0.doLinking(array, socket: socket)
            }
    }
}
