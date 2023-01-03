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
    func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol)
    func doLinking(_ elements: [ManagedObjectLinkable], anchor: ManagedObjectLinkerAnchorProtocol)
}

// MARK: - NSSet + ManagedObjectLinkHostable

extension NSSet: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol) {
        compactMap { $0 as? ManagedObjectLinkHostable }
            .forEach {
                $0.doLinking(element, anchor: anchor)
            }
    }

    public func doLinking(_ array: [ManagedObjectLinkable], anchor: ManagedObjectLinkerAnchorProtocol) {
        compactMap { $0 as? ManagedObjectLinkHostable }
            .forEach {
                $0.doLinking(array, anchor: anchor)
            }
    }
}
