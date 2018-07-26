//
//  WOTNode.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 6/25/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import ObjectiveC

public class WOTNode: NSObject, WOTNodeProtocol {

    static let WOTNodeEmptyComparator: WOTNodeComparatorType = { (node1, node2, level) in
        return .orderedSame
    }

    static let WOTNodeNameComparator: WOTNodeComparatorType = { (node1, node2, level) in
        return node1.name.compare(node2.name)
    }

    override public var hashValue: Int {
        return self.fullName.hashValue
    }

    override public var hash: Int {
        return self.fullName.hashValue
    }

    public subscript(index: Int) -> WOTNodeProtocol {
        get {
            return self.children[index]
        }
        set(newValue) {
            self.children[index] = newValue
        }
    }

    public var name: String = ""
    fileprivate var hiddenParent: WOTNodeProtocol?

    public var children: [WOTNodeProtocol] = [WOTNodeProtocol]()

    public private(set) var parent: WOTNodeProtocol?

    public var childList: Set<AnyHashable> = Set<AnyHashable>()

    public var isVisible: Bool = true

    public var fullName: String {
        guard let parent = self.parent else {
            return self.name
        }
        return String(format: "%@.%@", parent.fullName, self.name)
    }

    public func value(key: AnyHashable) -> Any? {
        return nil
    }

    public var index: Int = 0

    @objc
    public required init(name nameValue: String) {
        super.init()
        self.name = nameValue
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: self.name)
        result.isVisible = self.isVisible
        return result
    }

    public func addChild(_ child: WOTNodeProtocol) {
        child.addToParent(self)
        self.children.append(child)
    }

    public func addChildArray(_ childArray: [WOTNodeProtocol]) {
        childArray.forEach { (child) in
            child.addToParent(self)
            self.children.append(child)
        }
    }

    public func removeChild(_ child: WOTNodeProtocol, completion: @escaping (WOTNodeProtocol) -> Void) {
        guard let index = (self.children.index { $0 === child }) else {
            return
        }
        child.removeParent()
        child.removeChildren { (_) in

            self.children.remove(at: index)
            completion(self)
        }
    }

    public func removeChildren(completion: @escaping (WOTNodeProtocol) -> Void) {
        self.children.forEach { (child) in
            child.removeChildren(completion: { (node) in
                node.removeParent()
            })
        }
        self.children.removeAll()
        completion(self)
    }

    public func addToParent(_ newParent: WOTNodeProtocol) {
        self.unlinkFromParent()
        self.parent = newParent
    }

    public func removeParent() {
        guard let parent = self.parent else {
            return
        }
        self.parent = nil
        parent.removeChild(self) { (_ ) in

        }
    }

    public func unlinkChild(_ child: WOTNodeProtocol) {
        guard let index = (self.children.index { $0 === child }) else {
            return
        }
        child.removeParent()
        self.children.remove(at: index)
    }

    public func unlinkFromParent() {
        guard let parent = self.parent else {
            return
        }
        self.parent = nil
        parent.unlinkChild(self)
    }
}
