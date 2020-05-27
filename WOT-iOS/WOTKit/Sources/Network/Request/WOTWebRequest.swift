//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

open class WOTWEBRequest: WOTRequest {
    public var userInfo: JSON?
    public var httpBodyData: Data?

    deinit {
        //
    }

    override open var description: String {
        let pumperDescription: String
        if let pumper = pumper {
            pumperDescription = String(describing: pumper)
        } else {
            pumperDescription = ""
        }

        return "\(String(describing: type(of: self))) \(pumperDescription)"
    }

    override open var hash: Int {
        return (pumper as? NSObject)?.hash ?? path.hashValue
    }

    private var pumper: WOTWebDataPumperProtocol?

    override open func cancel(with error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, canceledWith: error)
        }
    }

    override open func start(withArguments: WOTRequestArgumentsProtocol) throws {
        guard let hostConfig = hostConfiguration else {
            throw WEBError.hostConfigurationIsNotDefined
        }
        self.pumper = WOTWebDataPumper(hostConfiguration: hostConfig, args: withArguments, httpBodyData: self.httpBodyData, service: self, completion: requestHasFinishedLoad(data:error:))
        self.pumper?.start()

        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, startedWith: hostConfig, args: withArguments)
        }
    }
}

// MARK: - WOTWebServiceProtocol

extension WOTWEBRequest: WOTWebServiceProtocol {
    open var method: HTTPMethods { return .POST }
    open var path: String { fatalError("WOTWEBRequest:path need to be overriden") }

    public func requestHasFinishedLoad(data: Data?, error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, finishedLoadData: data, error: error)
        }
    }
}
