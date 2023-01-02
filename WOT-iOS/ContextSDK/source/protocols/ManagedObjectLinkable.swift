//
//  ManagedObjectLinkable.swift
//  ContextSDK
//
//  Created by Paul on 2.01.23.
//

public protocol ManagedObjectLinkable {
    //
}

public protocol ManagedObjectLinkHostable {
    func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol)
    func doLinking(_ elements: [ManagedObjectLinkable], anchor: ManagedObjectLinkerAnchorProtocol)
}

extension NSSet: ManagedObjectLinkHostable {
    public func doLinking(_ element: ManagedObjectLinkable, anchor: ManagedObjectLinkerAnchorProtocol) {
        compactMap {$0 as? ManagedObjectLinkHostable}
            .forEach {
                $0.doLinking(element, anchor: anchor)
            }
    }

    public func doLinking(_ array: [ManagedObjectLinkable], anchor: ManagedObjectLinkerAnchorProtocol) {
        compactMap {$0 as? ManagedObjectLinkHostable}
            .forEach {
                $0.doLinking(array, anchor: anchor)
            }
    }
}
