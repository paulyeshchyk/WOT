//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

// MARK: - HttpDataReceiver

public class HttpDataReceiver: HttpDataReceiverProtocol, CustomStringConvertible {

    public var completion: ((Data?, Error?) -> Void)?

    public var MD5: String { uuid.MD5 }
    public var description: String { "\(type(of: self)): \(String(describing: request))" }

    let request: URLRequest

    private var state: State = .notStarted {
        didSet {
            let message = state.expandedDescription(for: request)
            appContext.logInspector?.log(.remoteFetch(message: message), sender: self)
        }
    }

    private let uuid: UUID = UUID()
    private var urlDataTask: URLSessionDataTask?

    private let appContext: Context

    // MARK: Lifecycle

    public required init(appContext: Context, request: URLRequest) {
        self.request = request
        self.appContext = appContext
    }

    deinit {
        if state != .finished {
            appContext.logInspector?.log(.warning("deinit HttpDataReceiver when state != finished"), sender: self)
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
            completion?(nil, nil)
        }
        return result
    }

    public func start() {
        urlDataTask?.cancelDataTask()
        urlDataTask = nil

        guard let url = request.url else {
            completion?(nil, Errors.urlNotDefined)
            return
        }
        urlDataTask = createDataTask(url: url) {
            self.state = .finished
        }
        urlDataTask?.resume()
    }

    // MARK: Private

    private func createDataTask(url: URL, completion cmpl: @escaping () -> Void) -> URLSessionDataTask {
        state = .started
        return URLSession.shared.dataTask(with: url) { [weak self] data, _, error in

            cmpl()

            guard let self = self else { return }

            DispatchQueue.main.async {
                self.completion?(data, error)
            }
        }
    }
}

// MARK: - %t + HttpDataReceiver.State

extension HttpDataReceiver {

    enum State {
        case notStarted
        case started
        case finished
        case canceled

        // MARK: Internal

        func expandedDescription(for request: URLRequest) -> String {
            switch self {
            case .canceled: return "cancel load URL: \(String(describing: request.url, orValue: "unknown"))"
            case .finished: return "finish load URL: \(String(describing: request.url, orValue: "unknown"))"
            case .notStarted: return "Not started URL: \(String(describing: request.url, orValue: "unknown"))"
            case .started: return "start load URL: \(String(describing: request.url, orValue: "unknown"))"
            }
        }
    }
}

// MARK: - %t + HttpDataReceiver.Errors

extension HttpDataReceiver {
    enum Errors: Error, CustomStringConvertible {
        case urlNotDefined

        var description: String {
            switch self {
            case .urlNotDefined: return "[\(type(of: self))]: Url is not defined"
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
