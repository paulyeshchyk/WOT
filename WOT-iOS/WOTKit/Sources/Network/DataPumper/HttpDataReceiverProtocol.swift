//
//  WOTWebDataPumperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public typealias DataReceiveCompletion = (Data?, Error?) -> Void

public protocol HttpDataReceiverProtocol {
    typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol
    
    var onStart: ((HttpDataReceiverProtocol) -> ())? { get set }
    var onComplete: ((HttpDataReceiverProtocol, Data?, Error?) -> ())? { get set }

    init(context: Context, request: URLRequest?)
    func start()
}
