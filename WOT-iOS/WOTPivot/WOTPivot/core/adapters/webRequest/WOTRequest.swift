//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTStartableProtocol {
    @objc
    func cancel()

    @objc
    @discardableResult
    func start(_ args: WOTRequestArgumentsProtocol) -> Bool
}

//public enum WOTRequestAction {
//    case new
//    case start
//    case finish
//    case cancel
//    case errorText(String)
//    case error(Error)
//    public var description: String {
//        switch self {
//        case .cancel: return "[CANCEL]:"
//        case .start: return "[RUN]:"
//        case .finish: return "[END]:"
//        case .new: return "[NEW]:"
//        case .errorText( _): return "[ERR]:"
//        case .error( _): return "[ERR]:"
//        }
//    }
//
//    public var details: String {
//        switch self {
//        case .errorText(let error): return error
//        case .error(let error):
//            if let error = error as? WOTWEBRequestError {
//                return error.description
//            } else {
//                return error.localizedDescription
//            }
//        default: return ""
//        }
//    }
//}

@objc
public protocol WOTDescribable {
    @objc
    var description: String { get }
}

@objc
public protocol WOTRequestProtocol: WOTStartableProtocol, WOTDescribable {
    @objc
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }

    @objc
    var listeners: [WOTRequestListenerProtocol] { get }

    @objc
    func addListener(_ listener: WOTRequestListenerProtocol)

    @objc
    func removeListener(_ listener: WOTRequestListenerProtocol)

    @objc
    var availableInGroups: [String] { get }

    @objc
    func addGroup(_ group: String)

    @objc
    func removeGroup(_ group: String)

    var uuid: UUID { get }

    var parentRequest: WOTRequestProtocol? { get set }
}

@objc
public enum WOTRequestManagerCompletionResultType: Int {
    case finished
    case noData
}

@objc
public protocol WOTRequestManagerListenerProtocol {
    @objc
    var hashData: Int { get }

    @objc
    func requestManager(_ requestManager: WOTRequestManagerProtocol, didParseDataForRequest: WOTRequestProtocol, completionResultType: WOTRequestManagerCompletionResultType)

    @objc
    func requestManager(_ requestManager: WOTRequestManagerProtocol, didStartRequest: WOTRequestProtocol)
}

@objc
public protocol WOTRequestManagerProtocol {
    @objc
    @discardableResult
    func start(_ request: WOTRequestProtocol, with arguments: WOTRequestArgumentsProtocol, forGroupId: String, jsonLink: WOTJSONLink?, externalCallback: NSManagedObjectCallback?) -> Bool

    @objc
    func addListener(_ listener: WOTRequestManagerListenerProtocol?, forRequest: WOTRequestProtocol)

    @objc
    func removeListener(_ listener: WOTRequestManagerListenerProtocol)

    @objc
    func cancelRequests(groupId: String)

    @objc
    var requestCoordinator: WOTRequestCoordinatorProtocol { get set }

    @objc
    var hostConfiguration: WOTHostConfigurationProtocol { get set }

    @objc
    var appManager: WOTAppManagerProtocol? { get set }
}

@objc
public protocol WOTRequestListenerProtocol {
    @objc
    var hash: Int { get }

    @objc
    func request(_ request: WOTRequestProtocol, finishedLoadData data: Data?, error: Error?)

    @objc
    func requestHasCanceled(_ request: WOTRequestProtocol)

    @objc
    func requestHasStarted(_ request: WOTRequestProtocol)

    @objc
    func removeRequest(_ request: WOTRequestProtocol)
}

@objc
open class WOTRequest: NSObject, WOTRequestProtocol, WOTStartableProtocol {
    public let uuid: UUID = UUID()

    @objc
    public var hostConfiguration: WOTHostConfigurationProtocol?

    @objc
    public var availableInGroups = [String]()

    @objc
    public var listeners = [WOTRequestListenerProtocol]()

    private var groups = [String]()

    @objc
    open func addGroup(_ group: String) {
        groups.append(group)
    }

    @objc
    open func removeGroup(_ group: String) {
        groups.removeAll(where: { group.compare($0) == .orderedSame })
    }

    @objc
    open func addListener(_ listener: WOTRequestListenerProtocol) {
        listeners.append(listener)
    }

    @objc
    open func removeListener(_ listener: WOTRequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { (obj) -> Bool in
            return (obj.hash == listener.hash)
        }) {
            listeners.remove(at: index)
        }
    }

    override open var hash: Int {
        return NSStringFromClass(type(of: self)).hash
    }

    @objc
    open func cancel() {}

    @objc
    @discardableResult
    open func start(_ args: WOTRequestArgumentsProtocol) -> Bool { return false }

    @objc
    public var parentRequest: WOTRequestProtocol?
}
