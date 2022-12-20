//
//  WOTWebRequest.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 3/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

open class HttpRequest: Request {

    public var httpBodyData: Data?

    override open var description: String {
        let pumperDescription: String
        if let pumper = httpDataReceiver {
            pumperDescription = String(describing: pumper)
        } else {
            pumperDescription = ""
        }

        return "\(String(describing: type(of: self))) \(pumperDescription)"
    }

    override open var hash: Int {
        return (httpDataReceiver as? NSObject)?.hash ?? path.hashValue
    }

    override open func cancel(with error: Error?) {
        self.listeners.compactMap { $0 }.forEach {
            $0.request(self, canceledWith: error)
        }
    }

    private var httpDataReceiver: HttpDataReceiverProtocol?
    override open func start(withArguments: RequestArgumentsProtocol) throws {
        let httpDataReceiver = HttpDataReceiver(context: context, args: withArguments, httpBodyData: httpBodyData, service: self)

        httpDataReceiver.onStart = { [weak self] _ in
            guard let self = self else { return }
            self.listeners.compactMap { $0 }.forEach {
                $0.request(self, startedWith: self.context.hostConfiguration, args: withArguments)
            }
        }
        httpDataReceiver.onComplete = { [weak self] _, data, error in
            guard let self = self else { return }
            self.listeners.compactMap { $0 }.forEach {
                $0.request(self, finishedLoadData: data, error: error)
            }
        }

        httpDataReceiver.start()
        self.httpDataReceiver = httpDataReceiver

    }
}

// MARK: - WOTWebServiceProtocol

extension HttpRequest: HttpServiceProtocol {
    open var method: HTTPMethods { return .POST }
    open var path: String { fatalError("WOTWEBRequest:path need to be overriden") }
}
