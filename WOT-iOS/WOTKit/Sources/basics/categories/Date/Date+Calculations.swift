//
//  Date+Calculations.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension Date {
    public func elapsed(from: Date) -> String {
        let elapsed = Date.timeIntervalSinceReferenceDate - from.timeIntervalSinceReferenceDate
        let elapsedStr = String(format: "%.5f", elapsed)
        return elapsedStr
    }
}
