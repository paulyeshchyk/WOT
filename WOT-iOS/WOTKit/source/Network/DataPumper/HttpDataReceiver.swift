//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - HttpDataReceiver

public class HttpDataReceiver: HttpDataReceiverProtocol {

    public required init(context: HttpDataReceiverProtocol.Context, request: URLRequest) {
        self.request = request
        self.context = context
    }

    deinit {
        urlDataTask?.cancelDataTask()
        urlDataTask = nil
    }

    public weak var delegate: HttpDataReceiverDelegateProtocol?

    public var MD5: String { uuid.MD5 }

    @discardableResult
    public func cancel() -> Bool {
        let result = urlDataTask?.cancelDataTask() ?? false
        urlDataTask = nil
        if result == true {
            delegate?.didCancel(urlRequest: request, receiver: self, error: nil)
        }
        return result
    }

    public func start(completion: @escaping (() -> Void)) {
        urlDataTask?.cancelDataTask()
        urlDataTask = nil

        guard let url = request.url else {
            delegate?.didEnd(urlRequest: request, receiver: self, data: nil, error: WOTWebDataPumperError.urlNotDefined)
            return
        }
        urlDataTask = createDataTask(url: url, completion: completion)
        delegate?.didStart(urlRequest: request, receiver: self)
        urlDataTask?.resume()
    }

    enum WOTWebDataPumperError: Error, CustomStringConvertible {
        case urlNotDefined

        var description: String {
            switch self {
            case .urlNotDefined: return "[\(type(of: self))]: Url is not defined"
            }
        }
    }

    let request: URLRequest

    private let uuid: UUID = UUID()
    private var urlDataTask: URLSessionDataTask?

    private let context: HttpDataReceiverProtocol.Context

    private func createDataTask(url: URL, completion: @escaping () -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            //
            completion()
            //
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.delegate?.didEnd(urlRequest: self.request, receiver: self, data: data, error: error)
            }
        }
    }
}

// MARK: - HttpDataReceiver + CustomStringConvertible

extension HttpDataReceiver: CustomStringConvertible {

    private var requestDescription: String { request.url?.absoluteString ?? String(describing: request) }

    public var description: String { "\(type(of: self)): \(requestDescription)" }

}

private extension URLSessionDataTask {
    var isCancelable: Bool {
        [URLSessionTask.State.running, URLSessionTask.State.suspended].contains(state)
    }

    @discardableResult
    func cancelDataTask() -> Bool {
        guard isCancelable else {
            return false
        }
        cancel()
        return true
    }
}
