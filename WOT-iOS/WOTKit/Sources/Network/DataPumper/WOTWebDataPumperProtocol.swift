//
//  WOTWebDataPumperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias DataReceiveCompletion = (Data?, Error?) -> Void

public protocol WOTWebDataPumperProtocol {
    var completion: DataReceiveCompletion { get }

    init(request: URLRequest, completion: @escaping DataReceiveCompletion)
    func start()
}
