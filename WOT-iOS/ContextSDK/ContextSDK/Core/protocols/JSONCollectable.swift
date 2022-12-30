//
//  JSONCollectable.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//
public typealias JSONValueType = Any
public typealias JSON = [Swift.AnyHashable: JSONValueType]

@objc
public protocol JSONCollectable {
    func add(element: JSON?) throws
    func add(array: [JSON]?) throws
    func data() -> Any?

    subscript(_: Int) -> JSON? { get }
}
