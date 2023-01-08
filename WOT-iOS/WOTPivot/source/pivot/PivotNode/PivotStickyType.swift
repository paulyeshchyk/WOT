//
//  PivotStickyType.swift
//  WOTPivot
//
//  Created by Paul on 1.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

public class PivotStickyType: NSObject, OptionSet {

    public static let float = PivotStickyType.init(rawValue: 1 << 0)
    public static let horizontal = PivotStickyType.init(rawValue: 1 << 1)
    public static let vertical = PivotStickyType.init(rawValue: 1 << 2)

    public var rawValue: Int

    // MARK: Lifecycle

    public required init(rawValue: Int) {
        self.rawValue = rawValue
        super.init()
    }

    // MARK: Public

    public func isInclude(_ options: PivotStickyType) -> Bool {
        return (rawValue & options.rawValue == options.rawValue)
    }

    public func inverted(_ options: PivotStickyType) -> PivotStickyType {
        if isInclude(options) {
            let result = (rawValue & ~options.rawValue)
            return Self.init(rawValue: result)
        } else {
            let result = (rawValue | options.rawValue)
            return Self.init(rawValue: result)
        }
    }
}
