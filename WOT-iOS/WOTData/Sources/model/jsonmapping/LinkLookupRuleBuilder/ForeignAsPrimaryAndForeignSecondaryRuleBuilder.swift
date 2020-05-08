//
//  ForeignAsPrimaryAndForeignSecondaryRuleBuilder.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/8/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

public class ForeignAsPrimaryAndForeignSecondaryRuleBuilder: LinkLookupRuleBuilderProtocol {
    private var pkCase: PKCase
    private var foreignPrimarySelectKey: String
    private var foreignSecondarySelectKey: String

    public init(pkCase: PKCase, foreignPrimarySelectKey: String, foreignSecondarySelectKey: String) {
        self.pkCase = pkCase
        self.foreignPrimarySelectKey = foreignPrimarySelectKey
        self.foreignSecondarySelectKey = foreignSecondarySelectKey
    }

    public func build() -> LinkLookupRule? {
        let resultCase = PKCase()
        resultCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignPrimarySelectKey)
        resultCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: foreignSecondarySelectKey)

        return LinkLookupRule(objectIdentifier: nil, pkCase: resultCase)
    }
}
