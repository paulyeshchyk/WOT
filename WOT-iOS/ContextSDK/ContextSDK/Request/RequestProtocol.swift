//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias WOTRequestIdType = String

@objc
public protocol RequestProtocol: StartableProtocol {
    var uuid: UUID { get }
    var availableInGroups: [String] { get }
    var hostConfiguration: HostConfigurationProtocol? { get set }
    var listeners: [RequestListenerProtocol] { get }
    var paradigm: MappingParadigmProtocol? { get set }

    func addGroup(_ group: WOTRequestIdType)
    func addListener(_ listener: RequestListenerProtocol)
    func removeGroup(_ group: String)
    func removeListener(_ listener: RequestListenerProtocol)
}

@objc
public protocol RequestListenerProtocol {
    @objc
    var hash: Int { get }

    @objc func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: RequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: RequestProtocol, startedWith hostConfiguration: HostConfigurationProtocol, args: RequestArgumentsProtocol)
}

