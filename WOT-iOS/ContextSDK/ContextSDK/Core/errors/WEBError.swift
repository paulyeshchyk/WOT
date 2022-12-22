//
//  WEBError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public enum WEBError: Error {
    case dataIsNull
    case invalidStatus
    case requestIsNotCreated
    case requestWasNotAddedToGroup
    case hostConfigurationIsNotDefined
    case urlNotCreated
}
