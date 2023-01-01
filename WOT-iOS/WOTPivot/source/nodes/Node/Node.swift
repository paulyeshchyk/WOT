//
//  WOTNode.swift
//  WOT-iOS
//
//  Created on 6/25/18.
//  Copyright © 2018. All rights reserved.
//

import ObjectiveC

open class Node: NSObject, NodeProtocol {
    @objc
    public required init(name nameValue: String) {
        super.init()
        name = nameValue
    }

    override open var hash: Int {
        return self.fullName.hashValue
    }

    open subscript(index: Int) -> NodeProtocol {
        get {
            return children[index]
        }
        set(newValue) {
            children[index] = newValue
            newValue.addToParent(self)
        }
    }

    open var name: String = ""
    fileprivate var hiddenParent: NodeProtocol?

    open var children: [NodeProtocol] = [NodeProtocol]()

    open private(set) var parent: NodeProtocol?

    open var isVisible: Bool = true

    open var fullName: String {
        guard let parent = self.parent else {
            return self.name
        }
        return String(format: "%@.%@", parent.fullName, self.name)
    }

    open func value(key _: AnyHashable) -> Any? {
        return nil
    }

    open var index: Int = 0

    open func copy(with _: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: name)
        result.isVisible = isVisible
        return result
    }

    open func addChild(_ child: NodeProtocol) {
        child.addToParent(self)
        children.append(child)
    }

    open func addChildArray(_ childArray: [NodeProtocol]) {
        childArray.forEach { (child) in
            child.addToParent(self)
            self.children.append(child)
        }
    }

    open func removeChild(_ child: NodeProtocol, completion: @escaping WOTNodeProtocolCompletion) {
        guard let index = (children.firstIndex { $0 === child }) else {
            return
        }
        child.removeParent()
        child.removeChildren { (_) in

            self.children.remove(at: index)
            completion(self)
        }
    }

    open func removeChildren(completion: WOTNodeProtocolCompletion?) {
        children.forEach { (child) in
            child.removeChildren(completion: { (node) in
                node.removeParent()
            })
        }
        children.removeAll()
        completion?(self)
    }

    open func addToParent(_ newParent: NodeProtocol) {
        unlinkFromParent()
        parent = newParent
    }

    open func removeParent() {
        guard let parent = parent else {
            return
        }
        self.parent = nil
        parent.removeChild(self) { (_) in
        }
    }

    open func unlinkChild(_ child: NodeProtocol) {
        guard let index = (children.firstIndex { $0 === child }) else {
            return
        }
        child.removeParent()
        children.remove(at: index)
    }

    open func unlinkFromParent() {
        guard let parent = parent else {
            return
        }
        self.parent = nil
        parent.unlinkChild(self)
    }
}
