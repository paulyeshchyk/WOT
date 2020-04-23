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
        guard let nonNil = anyValue else { return nil }
        if let float = nonNil as? Float { return NSDecimalNumber(value: float) }
        if let int = nonNil as? Int { return NSDecimalNumber(value: int) }
        return nil
    }

    public var asString: String? {
        guard let string = anyValue as? String else { return nil }
        return string
    }
}
