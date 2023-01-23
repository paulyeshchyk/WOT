//
//  WOTTankMetricOptions.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

@objc
public class WOTTankMetricOptions: NSObject, OptionSet {

    @objc public static let none = WOTTankMetricOptions(rawValue: 1 << 0)
    @objc public static let mobility = WOTTankMetricOptions(rawValue: 1 << 1)
    @objc public static let armor = WOTTankMetricOptions(rawValue: 1 << 2)
    @objc public static let observe = WOTTankMetricOptions(rawValue: 1 << 3)
    @objc public static let fire = WOTTankMetricOptions(rawValue: 1 << 4)

    @objc public var rawValue: Int

    // MARK: Lifecycle

    public required init(rawValue: Int) {
        self.rawValue = rawValue
        super.init()
    }

    // MARK: Public

    @objc public func isInclude(_ options: WOTTankMetricOptions) -> Bool {
        return (rawValue & options.rawValue == options.rawValue)
    }

    @objc public func inverted(_ options: WOTTankMetricOptions) -> WOTTankMetricOptions {
        if isInclude(options) {
            let result = (rawValue & ~options.rawValue)
            return WOTTankMetricOptions(rawValue: result)
        } else {
            let result = (rawValue | options.rawValue)
            return WOTTankMetricOptions(rawValue: result)
        }
    }
}
