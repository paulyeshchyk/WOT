//
//  PivotStickyType.swift
//  WOTPivot
//
//  Created by Paul on 1.01.23.
//  Copyright © 2023 Pavel Yeshchyk. All rights reserved.
//

// MARK: - StickyType

public enum StickyType: Int {
    case float
    case horizontal
    case vertical
}

// MARK: - PivotStickyType

public class PivotStickyType: NSObject, OptionSet {

    public var rawValue: Int

    public static func float() -> PivotStickyType {
        PivotStickyType(rawValue: StickyType.float.rawValue)
    }

    public static func horizontal() -> PivotStickyType {
        PivotStickyType(rawValue: StickyType.horizontal.rawValue)
    }

    public static func vertical() -> PivotStickyType {
        PivotStickyType(rawValue: StickyType.vertical.rawValue)
    }

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
