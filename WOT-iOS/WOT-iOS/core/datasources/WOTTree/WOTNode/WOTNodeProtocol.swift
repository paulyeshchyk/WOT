//
//  WOTNodeProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/20/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
public typealias WOTNodeProtocolRemoveCompletion = (WOTNodeProtocol) -> Void
internal typealias WOTNodeComparatorType = (_ node1: WOTNodeProtocol, _ node2: WOTNodeProtocol, _ level: Int) -> ComparisonResult

@objc public protocol WOTNodeProtocol: NSCopying, NSObjectProtocol {

    var hashString: String { get }

    var name: String { get set }

    var children: [WOTNodeProtocol] { get }

    var parent: WOTNodeProtocol? { get set }

    var childList: Set<AnyHashable> { get }

    var isVisible: Bool { get set }

    var fullName: String { get }

    var index: Int { get set }

    func addChild(_ child: WOTNodeProtocol)

    func addChildArray(_ childArray: [WOTNodeProtocol])

    func removeChild(_ child: WOTNodeProtocol, completion: WOTNodeProtocolRemoveCompletion)

    func removeChildren(_ completion: WOTNodeProtocolRemoveCompletion?)
}
