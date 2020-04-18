//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTWebServiceProtocol {
    var method: String { get }
    var path: String { get }
    func requestHasFinishedLoad(data: Data?, error: Error?)
}

@objc
public protocol WOTModelServiceProtocol: class {
    @objc
    static func modelClass() -> AnyClass?

    @objc
    func instanceModelClass() -> AnyClass?
}

@objc
open class WOTWEBRequest: WOTRequest, WOTWebServiceProtocol, NSURLConnectionDataDelegate {
    override open var description: String {
        return pumper?.description ?? "-"
    }

    public var userInfo: [AnyHashable: Any]?
    public var httpBodyData: Data?

    open var method: String { return "POST" }
    open var path: String { return "" }

    override open var hash: Int {
        return (pumper as? NSObject)?.hash ?? path.hashValue
    }

    public func requestHasFinishedLoad(data: Data?, error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, finishedLoadData: data, error: error)
        }
    }

    open override func cancel() {
        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasCanceled(self)
        }
    }

    var pumper: WOTWebDataPumperProtocol?

    @discardableResult
    open override func start(_ args: WOTRequestArgumentsProtocol) -> Bool {
        self.pumper = WOTWebDataPumper(hostConfiguration: hostConfiguration, args: args, httpBodyData: httpBodyData, service: self, completion: requestHasFinishedLoad(data:error:))
        self.pumper?.start()

        self.listeners.compactMap { $0 }.forEach {
            $0.requestHasStarted(self)
        }
        return true
    }
}
