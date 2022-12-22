//
//  JSONError.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/26/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public enum JSONError: Error {
    case empty(message: String = "JSON is empty")
    case parse(message: String)
}
