//
//  WOTRequestProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

public typealias RequestIdType = String

@objc
public protocol RequestProtocol: StartableProtocol, MD5Protocol {
    typealias Context = LogInspectorContainerProtocol & HostConfigurationContainerProtocol
    
    var availableInGroups: [String] { get }
    var listeners: [RequestListenerProtocol] { get }
    var paradigm: MappingParadigmProtocol? { get set }

    func addGroup(_ group: RequestIdType)
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
    var md5: String? { get }

    @objc func request(_ request: RequestProtocol, finishedLoadData data: Data?, error: Error?)
    @objc func request(_ request: RequestProtocol, canceledWith error: Error?)
    @objc func request(_ request: RequestProtocol, startedWith hostConfiguration: HostConfigurationProtocol?)
}

//@objc
open class Request: RequestProtocol, DescriptableProtocol {

    private enum RequestError: Error {
        case shouldBeOverriden(String)
        var debugDescription: String {
            switch self {
            case .shouldBeOverriden(let text): return "'\(text)' should be overridden"
            }
        }
    }
    
    public let context: RequestProtocol.Context
    public var MD5: String? { uuid.MD5 }
    public var description: String { String(describing: self) }
    
    public required init(context: RequestProtocol.Context) {
        self.context = context
    }
    

    private var groups = [RequestIdType]()

    open func cancel(with error: Error?) {}

    open func start(withArguments: RequestArgumentsProtocol) throws {
        throw RequestError.shouldBeOverriden("\(type(of: self))::\(#function)")
    }

    // MARK: - WOTRequestProtocol

    public let uuid: UUID = UUID()

    public var availableInGroups = [RequestIdType]()

    public var listeners = [RequestListenerProtocol]()

    public var paradigm: MappingParadigmProtocol?

    open func addGroup(_ group: RequestIdType) {
        groups.append(group)
    }

    open func addListener(_ listener: RequestListenerProtocol) {
        listeners.append(listener)
    }

    open func removeGroup(_ group: RequestIdType) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    open func removeListener(_ listener: RequestListenerProtocol) {
        listeners.removeAll(where: {$0.md5 == listener.md5 })
    }
}
