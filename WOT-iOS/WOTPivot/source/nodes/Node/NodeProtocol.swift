//
//  NodeProtocol.swift
//  WOT-iOS
//
//  Created on 7/20/18.
//  Copyright © 2018. All rights reserved.
//

public typealias WOTNodeProtocolCompletion = (NodeProtocol) -> Void
public typealias NodeComparatorType = (_ node1: NodeProtocol, _ node2: NodeProtocol, _ level: Int) -> ComparisonResult
public typealias NodeIndexType = Int

@objc
public protocol NodeProtocol: NSCopying, NSObjectProtocol {
    init(name nameValue: String)

    subscript(_: Int) -> NodeProtocol { get set }

    var name: String { get set }

    var children: [NodeProtocol] { get }

    var parent: NodeProtocol? { get }

    var isVisible: Bool { get set }

    var fullName: String { get }

    var index: NodeIndexType { get set }

    func addChild(_ child: NodeProtocol)

    func addChildArray(_ childArray: [NodeProtocol])

    func removeChild(_ child: NodeProtocol, completion: @escaping WOTNodeProtocolCompletion)

    func removeChildren(completion: WOTNodeProtocolCompletion?)

    func addToParent(_ newParent: NodeProtocol)

    func removeParent()

    func unlinkFromParent()

    func unlinkChild(_ child: NodeProtocol)

    func value(key: AnyHashable) -> Any?
}

extension NodeProtocol {
    func removeChildren() {
        removeChildren(completion: nil)
    }
}
