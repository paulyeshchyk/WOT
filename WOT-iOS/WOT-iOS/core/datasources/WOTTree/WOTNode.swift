//
//  WOTNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import ObjectiveC

public typealias WOTNodeProtocolRemoveCompletion = (WOTNodeProtocol) -> ()

@objc
public protocol WOTNodeProtocol: NSObjectProtocol, NSCopying {
    var hashString: String { get }
    var name: String { get set }
    var children: [WOTNodeProtocol] { get }
    var endpoints: [WOTNodeProtocol] { get }
    var parent: WOTNodeProtocol? { get set }
    var imageURL: NSURL { get set }
    var childList: Set<AnyHashable> { get }
    var isVisible: Bool { get set }
    var fullName: String { get }
    var index: Int { get set }
    var indexInsideStepParentColumn: Int { get set }
    var stepParentColumn: WOTNodeProtocol? { get set }
    var stepParentRow: WOTNodeProtocol? { get set }

    var relativeRect: NSValue? { get set }

    func addChild(_ child: WOTNodeProtocol)
    func addChildArray(_ childArray: [WOTNodeProtocol])
    func removeChild(_ child: WOTNodeProtocol, completion: WOTNodeProtocolRemoveCompletion)
    func removeChildren(_ completion: WOTNodeProtocolRemoveCompletion?)
}

public class WOTNodeSwift: NSObject, WOTNodeProtocol {

    override public var hashValue: Int {
        return self.fullName.hashValue
    }

    override public var hash: Int {
        return self.fullName.hashValue
    }

    public var hashString: String {
        return String(format: "%d", self.hashValue)
    }

    public var name: String = ""

    public var children: [WOTNodeProtocol] = [WOTNodeProtocol]()

    public var endpoints: [WOTNodeProtocol] {
        return WOTNodeEnumerator.sharedInstance.endpoints(node: self)
    }

    public var parent: WOTNodeProtocol?

    public var imageURL: NSURL = NSURL(string: "mock")!

    public var childList: Set<AnyHashable> = Set<AnyHashable>()

    public var isVisible: Bool = true

    public var fullName: String {
        guard let parent = self.parent else {
            return self.name
        }
        return String(format: "%@.%@", parent.fullName, self.name)
    }

    public var index: Int = 0

    public var indexInsideStepParentColumn: Int = 0

    public var stepParentColumn: WOTNodeProtocol?

    public var stepParentRow: WOTNodeProtocol?

    public var relativeRect: NSValue?

    @objc
    public required init(name nameValue: String) {
        super.init()
        self.name = nameValue
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: self.name)
        result.isVisible = self.isVisible
        result.imageURL = self.imageURL
        return result;
    }

    public func addChild(_ child: WOTNodeProtocol) {
        child.parent = self
        self.children.append(child)
    }

    public func addChildArray(_ childArray: [WOTNodeProtocol]) {
        childArray.forEach { (child) in
            child.parent = self
            self.children.append(child)
        }
    }

    public func removeChild(_ child: WOTNodeProtocol, completion: (WOTNodeProtocol) -> ()) {
        guard let index = (self.children.index { $0 === child }) else {
            return
        }
        child.parent = nil
        self.children.remove(at: index)
    }

    public func removeChildren(_ completion: WOTNodeProtocolRemoveCompletion?) {
        self.children.forEach { (child) in
            child.removeChildren({ (node) in

                node.parent = nil
            })
            completion?(child)
        }
        self.children.removeAll()
    }
}
