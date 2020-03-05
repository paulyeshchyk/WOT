//
//  WOTRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/5/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

//typedef void(^WOTRequestCallback)(NSDictionary *json, NSError *error, NSData *binary);

public typealias WOTRequestCallback = ( (JSON?, Error?, Data?) -> Void )

@objc
open class WOTRequest: NSObject {

    @objc
    public var hostConfiguration: WebHostConfigurationProtocol?

    @objc
    public var args: WOTRequestArguments?

    @objc
    public var availableInGroups = [Int]()

    @objc
    public var listeners = [WebRequestListenerProtocol]()

    @objc
    public var callback: WOTRequestCallback?
    
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
    open func addListener(_ listener: WebRequestListenerProtocol) {
        listeners.append(listener)
    }
    
    @objc
    open func removeListener(_ listener: WebRequestListenerProtocol) {
        if let index = listeners.firstIndex(where: { (obj) -> Bool in
            return (obj.hash == listener.hash)
        }) {
            listeners.remove(at: index)
        }
    }

    @objc
    open func cancel() {
        
    }
    
    @objc
    open func start(_ args: WOTRequestArguments) {
        
    }
    
    @objc
    open func cancelAndRemoveFromQueue() {
        
    }
    
}
