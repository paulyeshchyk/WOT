//
//  WOTTankEvalutionResult.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import UIKit

// MARK: - WOTTankEvaluationResultProtocol

@objc
public protocol WOTTankEvaluationResultProtocol {
    var thisValue: CGFloat { get set }
    var maxValue: CGFloat { get set }
    var averageValue: CGFloat { get set }
}

// MARK: - WOTTankEvalutionResult

@objc
public class WOTTankEvalutionResult: NSObject, WOTTankEvaluationResultProtocol {

    @objc
    public required
    init(thisValue: CGFloat, maxValue: CGFloat, averageValue: CGFloat) {
        self.thisValue = thisValue
        self.maxValue = maxValue
        self.averageValue = averageValue
        super.init()
    }

    @objc
    public var thisValue: CGFloat

    @objc
    public var maxValue: CGFloat

    @objc
    public var averageValue: CGFloat
}
