//
//  NSDictionary+Append.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

import Foundation

/*
 https://medium.com/ios-swift-development-notes/swiftbites-8-merging-dictionaries-in-swift-894c3e235fec
 */
public extension Dictionary {
    /// Merge and return a new dictionary
    func merge(with: [Key: Value]) -> [Key: Value] {
        var copy = self
        for (k, v) in with {
            // If a key is already present it will be overritten
            copy[k] = v
        }
        return copy
    }

    /// Merge in-place
    mutating func append(with: [Key: Value]) {
        for (k, v) in with {
            // If a key is already present it will be overritten
            self[k] = v
        }
    }
}
