//
//  WOTDimensionProtocol.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
public protocol WOTDimensionProtocol: NSObjectProtocol {

    init(fetchController: WOTDataFetchControllerProtocol, enumerator: WOTNodeEnumeratorProtocol)

    var shouldDisplayEmptyColumns: Bool { get }

    var contentSize: CGSize { get }

    func setMaxWidth(_ maxWidth: Int, forNode: WOTNodeProtocol, byKey: String)

    func maxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int

    func childrenMaxWidth(_ node: WOTNodeProtocol, orValue: Int) -> Int

    func reload(forIndex: Int)
}
