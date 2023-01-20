//
//  UoW_ManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 20.01.23.
//

// MARK: - UoW_Config_Protocol

@objc
public protocol UoW_Config_Protocol {
    var uowType: UoW_Protocol.Type { get }
}

// MARK: - UoW_Listener

@objc
public protocol UoW_Listener {
    func didFinishUOW(_ uow: UoW_Protocol, error: Error?)
}

// MARK: - UoW_Status

@objc
public enum UoW_Status: Int {
    case initialization
    case inProgress
    case finish
}

// MARK: - UoW_Protocol

@objc
public protocol UoW_Protocol: MD5Protocol {
    var data: UoW_Config_Protocol { get }
    var status: UoW_Status { get }
    var didStatusChanged: ((_ uow: UoW_Protocol) -> Void)? { get set }

    init(config: UoW_Config_Protocol) throws
    func run(forListener: UoW_Listener) throws
}

// MARK: - UoW_ManagerProtocol

@objc
public protocol UoW_ManagerProtocol {
    func perform(uow: UoW_Protocol) throws
    func uow(by: UoW_Config_Protocol) throws -> UoW_Protocol
}

// MARK: - UoW_ManagerContainerProtocol

@objc
public protocol UoW_ManagerContainerProtocol {
    var uowManager: UoW_ManagerProtocol { get set }
}
