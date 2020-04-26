//
//  DataAdapterError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public enum DataAdapterError: WOTError {
    case requestNotRegistered(requestType: String)
    case adapterNotFound(requestType: String)
    case classIsNotDataAdapter(dataAdapter: String)
}
