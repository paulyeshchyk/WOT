//
//  NSDecimalNumber+Conversion.swift
//  ContextSDK
//
//  Created by Paul on 28.12.22.
//

import Foundation

public extension Int {
    var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self) }
}

public extension Bool {
    var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self) }
}

public extension Float {
    var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self) }
}

public extension Double {
    var asDecimal: NSDecimalNumber { return NSDecimalNumber(value: self) }
}

// MARK: - NSDecimalNumberArray

public class NSDecimalNumberArray {

    public typealias Fields = DataFieldsKeys
    public enum DataFieldsKeys: String, CodingKey {
        case elements
    }

    public var elements: [NSDecimalNumber]

    // MARK: Lifecycle

    public init(array: [Any]?) throws {
        guard let array = array else {
            throw NSDecimalArrayConversionError.cantInitWithNil
        }
        elements = NSDecimalNumberArray.conversion(from: array)
    }

    // MARK: Public

    public subscript(index: Int) -> NSDecimalNumber {
        get {
            return elements[index]
        }
        set(newValue) {
            elements[index] = newValue
        }
    }

    // MARK: Private

    private static func conversion(from: Any?) -> NSDecimalNumber? {
        guard let nonNil = from else { return nil }
        if let double = nonNil as? Double { return NSDecimalNumber(value: double) }
        if let int = nonNil as? Int { return NSDecimalNumber(value: int) }
        return nil
    }

    private static func conversion(from: [Any?]) -> [NSDecimalNumber] {
        var result: [NSDecimalNumber] = .init()
        let elems = from.compactMap { ($0) }
        elems.forEach { element in
            if let double = element as? Double { result.append(NSDecimalNumber(value: double)) }
            if let int = element as? Int { result.append(NSDecimalNumber(value: int)) }
        }
        return result
    }
}

// MARK: - NSDecimalArrayConversionError

private enum NSDecimalArrayConversionError: Error {
    case cantInitWithNil
}
