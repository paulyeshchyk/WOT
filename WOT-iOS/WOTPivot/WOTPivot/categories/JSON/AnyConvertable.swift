//
//  AnyConvertable.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/19/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public struct AnyConvertable {
    private var anyValue: Any?
    public init(_ withAny: Any?) {
        anyValue = withAny
    }

    public var asNSDecimal: NSDecimalNumber? {
        guard let any = anyValue else { return nil }
        if let int = any as? Int { return NSDecimalNumber(value: int) }
        return nil
    }
}

//extension Any {
//    var stringValue: String? {
//        guard let string = self as? String else { return nil }
//        return string
//    }
//
//    var intValue: Int? {
//        guard let intValue = self as? Int else { return nil }
//        return intValue
//    }
//
//    var nsDecimalValue: NSDecimalNumber? {
//        guard let intValue = self as? Int else { return nil }
//        return NSDecimalNumber(value: intValue)
//    }
//}
