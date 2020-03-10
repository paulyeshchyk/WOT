//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTRequestProtocol: class {
    
    @objc
    var hostConfiguration: WOTHostConfigurationProtocol? { get set }
    
    @objc
    func cancel()
    
    @objc
    func start(_ args: WOTRequestArguments?) -> Bool
    
    @objc
    var listeners:[WOTRequestListenerProtocol] { get }
    
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
    
    var hash: Int { get }
    
}

@objc
public protocol WOTRequestListenerProtocol {
    
    @objc
    var hash: Int { get }

    @objc
    func request(_ request: AnyObject, finishedLoadData data:Data?, error: Error?)
    
    @objc
    func requestHasCanceled(_ request: WOTRequestProtocol)
    
    @objc
    func requestHasStarted(_ request: WOTRequestProtocol)
    
    @objc
    func removeRequest(_ request: WOTRequestProtocol)
}

@objc
public protocol WOTStartableProtocol {

    @objc
    func cancel()
    
    @objc
    @discardableResult
    func start(_ args: WOTRequestArguments?) -> Bool
    
}

@objc
open class WOTRequest: NSObject, WOTRequestProtocol, WOTStartableProtocol {

    @objc
    public var hostConfiguration: WOTHostConfigurationProtocol?
    
    @objc
    public var availableInGroups = [String]()

    @objc
    public var listeners = [WOTRequestListenerProtocol]()

    private var groups = [String]()

    @objc
    open func addGroup(_ group: String ) {
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
    //TODO: refactoring
    override open var hash: Int {
        
        return NSStringFromClass(type(of:self)).hash
    }
    
    
    @objc
    open func cancel() { }
    
    @objc
    @discardableResult
    open func start(_ args: WOTRequestArguments?) -> Bool { return false }
    
}
