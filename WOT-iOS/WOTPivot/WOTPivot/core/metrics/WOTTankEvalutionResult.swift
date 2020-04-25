//
//  WOTTankEvalutionResult.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTTankEvaluationResultProtocol {
    var thisValue: CGFloat { get set }
    var maxValue: CGFloat { get set }
    var averageValue: CGFloat { get set }
}

@objc
public class WOTTankEvalutionResult: NSObject, WOTTankEvaluationResultProtocol {
    @objc
    public var thisValue: CGFloat

    @objc
    public var maxValue: CGFloat

    @objc
    public var averageValue: CGFloat

    @objc
    required
    public init(thisValue: CGFloat, maxValue: CGFloat, averageValue: CGFloat) {
        self.thisValue = thisValue
        self.maxValue = maxValue
        self.averageValue = averageValue
        super.init()
    }
}
