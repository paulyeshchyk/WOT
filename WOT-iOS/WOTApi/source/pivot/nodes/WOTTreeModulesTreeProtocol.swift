//
//  WOTTreeModuleNodeProtocol.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

// MARK: - WOTTreeModulesTreeProtocol

@objc
public protocol WOTTreeModulesTreeProtocol: NSObjectProtocol {
    func moduleIdInt() -> Int
    func moduleName() -> String
    func moduleType() -> String?
    func moduleLocalImageURL() -> URL?
    func moduleValue(forKey: String) -> Any?
    func next_nodesId() -> [Int]?
}

// MARK: - WOTTreeModuleNodeProtocol

@objc
public protocol WOTTreeModuleNodeProtocol: NodeProtocol {
    var modulesTree: WOTTreeModulesTreeProtocol { get }
    var imageURL: URL? { get }
}
