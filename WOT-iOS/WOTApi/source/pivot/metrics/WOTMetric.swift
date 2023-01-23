//
//  WOTMetric.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - WOTTankMetricEvaluatorProtocol

@objc
public protocol WOTTankMetricEvaluatorProtocol: NSObjectProtocol {
    func evaluate(list: WOTTanksIDListProtocol) -> WOTTankEvaluationResultProtocol?
}

// MARK: - WOTMetricProtocol

@objc
public protocol WOTMetricProtocol: NSObjectProtocol {
    var metricName: String? { get set }
    var evaluator: WOTTankMetricEvaluatorProtocol? { get set }
    var grouppingName: String? { get set }
}

// MARK: - WOTMetric

@objc public class WOTMetric: NSObject, WOTMetricProtocol {

    @objc
    public required init(metricName: String?, grouppingName: String?, evaluator: WOTTankMetricEvaluatorProtocol?) {
        self.metricName = metricName
        self.evaluator = evaluator
        self.grouppingName = grouppingName
    }

    public var metricName: String?
    public var evaluator: WOTTankMetricEvaluatorProtocol?
    public var grouppingName: String?
}
