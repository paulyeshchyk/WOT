//
//  WOTTreeModuleNodeProtocol.swift
//  WOT-iOS
//
//  Created on 7/23/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
public protocol WOTTreeModulesTreeProtocol: NSObjectProtocol {
    func moduleIdInt() -> Int
    func moduleName() -> String
    func moduleType() -> String?
    func moduleLocalImageURL() -> URL?
    func moduleValue(forKey: String) -> Any?
    func next_nodesId() -> [Int]?
}

@objc
public protocol WOTTreeModuleNodeProtocol: WOTNodeProtocol {
    var modulesTree: WOTTreeModulesTreeProtocol { get }
    var imageURL: URL? { get }
}
