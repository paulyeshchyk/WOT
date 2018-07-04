//
//  WOTNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import ObjectiveC

public typealias WOTNodeProtocolRemoveCompletion = ( WOTNodeProtocol )->()

@objc
public protocol WOTNodeProtocol: NSObjectProtocol, NSCopying {
    var name: String { get set }
    var children: [WOTNodeProtocol] { get }
    var parent: WOTNodeProtocol? { get set }
    var imageURL: NSURL { get set }
    var childList: Set<AnyHashable> { get }
    var isVisible: Bool { get set }
    var fullName: String { get }
    init()
    init(name: String)
    init(name: String, imageURL: NSURL)
    func addChild(_ child: WOTNodeProtocol)
    func addChildArray(_ childArray: [WOTNodeProtocol])
    func removeChild(_ child: WOTNodeProtocol, completion: WOTNodeProtocolRemoveCompletion)
    func removeChildren(_ completion: WOTNodeProtocolRemoveCompletion?)
}

@objc
public class WOTNodeSwift: NSObject {
    override public init() {
        super.init()
    }

}
