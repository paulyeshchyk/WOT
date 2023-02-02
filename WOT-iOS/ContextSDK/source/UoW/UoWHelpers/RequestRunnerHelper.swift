//
//  RequestRunnerHelper.swift
//  ContextSDK
//
//  Created by Paul on 29.01.23.
//

class RequestRunnerHelper {
    typealias Context = LogInspectorContainerProtocol

    var completion: ((RequestProtocol?, Data?, Error?) -> Void)?
    private var request: RequestProtocol?

    private let appContext: Context
    init(appContext: Context) {
        self.appContext = appContext
    }

    func run(_ request: RequestProtocol?) {
        self.request = request
        guard let request = self.request else {
            completion?(nil, nil, nil)
            return
        }
        request.completion = { data, error in
            self.completion?(self.request, data, error)
            self.request = nil
        }

        do {
            try request.start()
        } catch {
            completion?(request, nil, error)
            self.request = nil
        }
    }
}
