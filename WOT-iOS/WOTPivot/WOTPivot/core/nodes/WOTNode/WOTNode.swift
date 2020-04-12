//
//  WOTNode.swift
//  WOT-iOS
//
//  Created on 6/25/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import ObjectiveC

open class WOTNode: NSObject, WOTNodeProtocol {
    @objc
    public required init(name nameValue: String) {
        super.init()
        self.name = nameValue
    }

//    override open var hashValue: Int {
//        return self.fullName.hashValue
//    }

    override open var hash: Int {
        return self.fullName.hashValue
    }

    open subscript(index: Int) -> WOTNodeProtocol {
        get {
            return self.children[index]
        }
        set(newValue) {
            self.children[index] = newValue
            newValue.addToParent(self)
        }
    }

    open var name: String = ""
    fileprivate var hiddenParent: WOTNodeProtocol?

    open var children: [WOTNodeProtocol] = [WOTNodeProtocol]()

    open private(set) var parent: WOTNodeProtocol?

    open var isVisible: Bool = true

    open var fullName: String {
        guard let parent = self.parent else {
            return self.name
        }
        return String(format: "%@.%@", parent.fullName, self.name)
    }

    open func value(key: AnyHashable) -> Any? {
        return nil
    }

    open var index: Int = 0

    open func copy(with zone: NSZone? = nil) -> Any {
        let result = type(of: self).init(name: self.name)
        result.isVisible = self.isVisible
        return result
    }

    open func addChild(_ child: WOTNodeProtocol) {
        child.addToParent(self)
        self.children.append(child)
    }

    open func addChildArray(_ childArray: [WOTNodeProtocol]) {
        childArray.forEach { (child) in
            child.addToParent(self)
            self.children.append(child)
        }
    }

    open func removeChild(_ child: WOTNodeProtocol, completion: @escaping (WOTNodeProtocol) -> Void) {
        guard let index = (self.children.firstIndex { $0 === child }) else {
            return
        }
        child.removeParent()
        child.removeChildren { (_) in

            self.children.remove(at: index)
            completion(self)
        }
    }

    open func removeChildren(completion: @escaping (WOTNodeProtocol) -> Void) {
        self.children.forEach { (child) in
            child.removeChildren(completion: { (node) in
                node.removeParent()
            })
        }
        self.children.removeAll()
        completion(self)
    }

    open func addToParent(_ newParent: WOTNodeProtocol) {
        self.unlinkFromParent()
        self.parent = newParent
    }

    open func removeParent() {
        guard let parent = self.parent else {
            return
        }
        self.parent = nil
        parent.removeChild(self) { (_) in
        }
    }

    open func unlinkChild(_ child: WOTNodeProtocol) {
        guard let index = (self.children.firstIndex { $0 === child }) else {
            return
        }
        child.removeParent()
        self.children.remove(at: index)
    }

    open func unlinkFromParent() {
        guard let parent = self.parent else {
            return
        }
        self.parent = nil
        parent.unlinkChild(self)
    }
}
