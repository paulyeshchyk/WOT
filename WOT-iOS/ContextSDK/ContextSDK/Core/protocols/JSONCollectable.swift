//
//  JSONCollectable.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

public typealias JSON = Swift.Dictionary<Swift.AnyHashable, Any>

@objc
public protocol JSONCollectable {
    func add(element: JSON?) throws
    func add(array: [JSON]?) throws
    func data() -> Any?

    subscript(index: Int) -> JSON? { get }
}
