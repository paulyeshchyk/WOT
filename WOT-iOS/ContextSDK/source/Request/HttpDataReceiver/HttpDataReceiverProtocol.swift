//
//  WOTWebDataPumperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias DataReceiveCompletion = (Data?, Error?) -> Void

// MARK: - HttpDataReceiverProtocol

public protocol HttpDataReceiverProtocol: MD5Protocol {

    typealias Context = LogInspectorContainerProtocol
        & HostConfigurationContainerProtocol

    var completion: ((Data?, Error?) -> Void)? { get set }

    init(appContext: Context, request: URLRequest)
    func start()

    @discardableResult
    func cancel() -> Bool
}
