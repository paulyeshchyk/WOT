//
//  WOTWebDataPumperProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public typealias DataReceiveCompletion = (Data?, Error?) -> Void

public protocol HttpDataReceiverProtocol: MD5Protocol {
    typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol
    
    var delegate: HttpDataReceiverDelegateProtocol? { get set }
    
    init(context: Context, request: URLRequest)
    func start()
}

public protocol HttpDataReceiverDelegateProtocol: AnyObject {
    func didStart(urlRequest: URLRequest, receiver: HttpDataReceiverProtocol)
    func didEnd(urlRequest: URLRequest, receiver: HttpDataReceiverProtocol, data: Data?, error: Error?)
}
