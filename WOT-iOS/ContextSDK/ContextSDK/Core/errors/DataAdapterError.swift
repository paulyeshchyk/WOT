//
//  DataAdapterError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public enum DataAdapterError: Error {
    case requestNotRegistered(requestType: String)
    case classIsNotDataAdapter(dataAdapter: String)
}
