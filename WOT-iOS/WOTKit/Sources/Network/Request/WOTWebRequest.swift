//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
open class WOTWEBRequest: WOTRequest, WOTWebServiceProtocol, NSURLConnectionDataDelegate {
    override open var description: String {
        let pumperDescription = pumper?.wotDescription ?? ""
        return "\(String(describing: type(of: self))) \(pumperDescription)"
    }

    public var userInfo: JSON?
    public var httpBodyData: Data?

    open var method: String { return "POST" }
    open var path: String { fatalError("WOTWEBRequest:path need to be overriden") }

    override open var hash: Int {
        return (pumper as? NSObject)?.hash ?? path.hashValue
    }

    public func requestHasFinishedLoad(data: Data?, error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, finishedLoadData: data, error: error)
        }
    }

    open override func cancel(with error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, canceledWith: error)
        }
    }

    var pumper: WOTWebDataPumperProtocol?

    open override func start(withArguments: WOTRequestArgumentsProtocol) throws {
        guard let hostConfig = hostConfiguration else {
            throw WEBError.hostConfigurationIsNotDefined
        }
        self.pumper = WOTWebDataPumper(hostConfiguration: hostConfig, args: withArguments, httpBodyData: httpBodyData, service: self, completion: requestHasFinishedLoad(data:error:))
        self.pumper?.start()

        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, startedWith: hostConfig, args: withArguments)
        }
    }
}
