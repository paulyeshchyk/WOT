//
//  NodeIndexProtocol.swift
//  WOTPivot
//
//  Created on 8/16/18.
//  Copyright © 2018. All rights reserved.
//

public typealias NodeLevelType = Int
public let NodeLevelTypeZero: Int = 0

// MARK: - NodeIndexProtocol

@objc
public protocol NodeIndexProtocol {
    var count: Int { get }
    func doAutoincrementIndex(forNodes: [NodeProtocol]) -> Int
    func reset()
    func item(indexPath: IndexPath) -> NodeProtocol?
    func add(nodes: [NodeProtocol], level: NodeLevelType)
    func add(node: NodeProtocol, level: NodeLevelType)
    init()
}
