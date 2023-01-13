//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

// MARK: - HttpDataReceiver

public class HttpDataReceiver: HttpDataReceiverProtocol, CustomStringConvertible {

    public weak var delegate: HttpDataReceiverDelegateProtocol?

    public var MD5: String { uuid.MD5 }
    public var description: String { "\(type(of: self)): \(String(describing: request))" }

    enum State {
        case notStarted
        case started
        case finished
        case canceled

        // MARK: Internal

        func expandedDescription(for request: URLRequest) -> String {
            switch self {
            case .canceled: return "Cancel URL: \(String(describing: request.url, orValue: "unknown"))"
            case .finished: return "Finished URL: \(String(describing: request.url, orValue: "unknown"))"
            case .notStarted: return "Not started URL: \(String(describing: request.url, orValue: "unknown"))"
            case .started: return "Start URL: \(String(describing: request.url, orValue: "unknown"))"
            }
        }
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

    private var state: State = .notStarted {
        didSet {
            let message = state.expandedDescription(for: request)
            context.logInspector?.log(.remoteFetch(message: message), sender: self)
        }
    }

    private let uuid: UUID = UUID()
    private var urlDataTask: URLSessionDataTask?

    private let context: HttpDataReceiverProtocol.Context

    // MARK: Lifecycle

    public required init(context: HttpDataReceiverProtocol.Context, request: URLRequest) {
        self.request = request
        self.context = context
    }

    deinit {
        if state != .finished {
            context.logInspector?.log(.warning("deinit HttpDataReceiver when state != finished"), sender: self)
        }
        urlDataTask?.cancelDataTask()
        urlDataTask = nil
    }

    // MARK: Public

    @discardableResult
    public func cancel() -> Bool {
        let result = urlDataTask?.cancelDataTask() ?? false
        urlDataTask = nil
        if result == true {
            state = .canceled
            delegate?.didCancel(urlRequest: request, receiver: self, error: nil)
        }
        return result
    }

    public func start() {
        urlDataTask?.cancelDataTask()
        urlDataTask = nil

        guard let url = request.url else {
            delegate?.didEnd(urlRequest: request, receiver: self, data: nil, error: WOTWebDataPumperError.urlNotDefined)
            return
        }
        urlDataTask = createDataTask(url: url) {
            self.state = .finished
        }
        delegate?.didStart(urlRequest: request, receiver: self)
        urlDataTask?.resume()
    }

    // MARK: Private

    private func createDataTask(url: URL, completion: @escaping () -> Void) -> URLSessionDataTask {
        state = .started
        return URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            completion()

            guard let self = self else { return }

            DispatchQueue.main.async {
                self.delegate?.didEnd(urlRequest: self.request, receiver: self, data: data, error: error)
            }
        }
    }
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
