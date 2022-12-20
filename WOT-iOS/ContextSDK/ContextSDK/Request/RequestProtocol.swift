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
    typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol
    
    var uuid: UUID { get }
    var availableInGroups: [String] { get }
    var listeners: [RequestListenerProtocol] { get }
    var paradigm: MappingParadigmProtocol? { get set }

    func addGroup(_ group: WOTRequestIdType)
    func addListener(_ listener: RequestListenerProtocol)
    func removeGroup(_ group: String)
    func removeListener(_ listener: RequestListenerProtocol)
    init(context: Context)
}

@objc
public protocol RequestListenerContainerProtocol {
    @objc var requestListener: RequestListenerProtocol? { get set }
}

@objc
public protocol RequestListenerProtocol {
    @objc
    var hash: Int { get }

    @objc func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: RequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: RequestProtocol, startedWith hostConfiguration: HostConfigurationProtocol?, args: RequestArgumentsProtocol)
}

@objc
open class Request: NSObject, RequestProtocol {

    public let context: RequestProtocol.Context
    
    public required init(context: RequestProtocol.Context) {
        self.context = context
    }
    
    override open var description: String {
        return String(describing: type(of: self))
    }

    override open var hash: Int {
        return uuid.hashValue
    }

    private var groups = [WOTRequestIdType]()

    open func cancel(with error: Error?) {}

    open func start(withArguments: RequestArgumentsProtocol) throws {
        throw LogicError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    // MARK: - WOTRequestProtocol

    public let uuid: UUID = UUID()

    public var availableInGroups = [WOTRequestIdType]()

    public var listeners = [RequestListenerProtocol]()

    public var paradigm: MappingParadigmProtocol?

    open func addGroup(_ group: WOTRequestIdType) {
        groups.append(group)
    }

    open func addListener(_ listener: RequestListenerProtocol) {
        listeners.append(listener)
    }

    open func removeGroup(_ group: WOTRequestIdType) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    open func removeListener(_ listener: RequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { $0.hash == listener.hash }) {
            listeners.remove(at: index)
        }
    }
}
