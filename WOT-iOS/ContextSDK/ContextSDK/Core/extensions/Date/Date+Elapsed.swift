//
//  Date+Elapsed.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

extension Date {
    public func elapsed(from: Date) -> String {
        let elapsed = Date.timeIntervalSinceReferenceDate - from.timeIntervalSinceReferenceDate
        let elapsedStr = String(format: "%.5f", elapsed)
        return elapsedStr
    }
}
