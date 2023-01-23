//
//  NSDecimalNumber+Conversion.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/27/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension Int {
    public var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self)}
}

extension Bool {
    public var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self)}
}

extension Float {
    public var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self)}
}

extension Double {
    public var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self)}
}

public class NSDecimalNumberArray {
    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case elements
    }

    public var elements: [NSDecimalNumber]

    public init(array: [Any]) {
        self.elements = NSDecimalNumberArray.conversion(from: array)
    }

    private static func conversion(from: Any?) -> NSDecimalNumber? {
        guard let nonNil = from else { return nil }
        if let double = nonNil as? Double { return NSDecimalNumber(value: double) }
        if let int = nonNil as? Int { return NSDecimalNumber(value: int) }
        return nil
    }

    private static func conversion(from: [Any?]) -> [NSDecimalNumber] {
        var result: [NSDecimalNumber] = .init()
        let elems = from.compactMap {($0)}
        elems.forEach { element in
            if let double = element as? Double { result.append(NSDecimalNumber(value: double)) }
            if let int = element as? Int { result.append(NSDecimalNumber(value: int)) }
        }
        return result
    }

    public subscript(index: Int) -> NSDecimalNumber {
        get {
            return self.elements[index]
        }
        set(newValue) {
            self.elements[index] = newValue
        }
    }
}
