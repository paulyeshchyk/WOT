//
//  WOTNodeProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

public typealias WOTNodeProtocolCompletion = (WOTNodeProtocol) -> Void
public typealias WOTNodeComparatorType = (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult

@objc
public protocol WOTNodeProtocol: NSCopying, NSObjectProtocol {
    init(name nameValue: String)

    subscript(_: Int) -> WOTNodeProtocol { get set }

    var name: String { get set }

    var children: [WOTNodeProtocol] { get }

    var parent: WOTNodeProtocol? { get }

    var isVisible: Bool { get set }

    var fullName: String { get }

    var index: Int { get set }

    func addChild(_ child: WOTNodeProtocol)

    func addChildArray(_ childArray: [WOTNodeProtocol])

    func removeChild(_ child: WOTNodeProtocol, completion: @escaping WOTNodeProtocolCompletion)

    func removeChildren(completion: WOTNodeProtocolCompletion?)

    func addToParent(_ newParent: WOTNodeProtocol)

    func removeParent()

    func unlinkFromParent()

    func unlinkChild(_ child: WOTNodeProtocol)

    func value(key: AnyHashable) -> Any?
}

extension WOTNodeProtocol {
    func removeChildren() {
        removeChildren(completion: nil)
    }
}
