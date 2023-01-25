//
//  NodeDimensionProtocol.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

// MARK: - NodeDimensionProtocol

@objc
public protocol NodeDimensionProtocol: NSObjectProtocol {
    var fetchController: NodeFetchControllerProtocol? { get set }

    var enumerator: NodeEnumeratorProtocol? { get set }

    var shouldDisplayEmptyColumns: Bool { get }

    var contentSize: CGSize { get }

    func setMaxWidth(_ maxWidth: Int, forNode: NodeProtocol, byKey: String)

    func maxWidth(_ node: NodeProtocol, orValue: Int) -> Int

    func childrenMaxWidth(_ node: NodeProtocol, orValue: Int) -> Int

    func reload(forIndex: Int, nodeCreator: NodeCreatorProtocol?)
}

// MARK: - DimensionLoadListenerProtocol

public protocol DimensionLoadListenerProtocol: AnyObject {
    func didLoad(dimension: NodeDimensionProtocol)
}
