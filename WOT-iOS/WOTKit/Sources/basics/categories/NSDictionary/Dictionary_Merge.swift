//
//  Dictionary_Merge.swift
//  WOTPivot
//
//  Created on 2/14/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

/*
 https://medium.com/ios-swift-development-notes/swiftbites-8-merging-dictionaries-in-swift-894c3e235fec
 */
extension Dictionary {
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

extension Dictionary {
    public func debugOutput(options: JSONSerialization.WritingOptions = [.withoutEscapingSlashes, .prettyPrinted]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            return "\(error.localizedDescription)"
        }
    }
}
