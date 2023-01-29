//
//  RequestRunnerHelper.swift
//  ContextSDK
//
//  Created by Paul on 29.01.23.
//

class RequestRunnerHelper {
    typealias Context = LogInspectorContainerProtocol
        & RequestRegistratorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & UOWManagerContainerProtocol

    var completion: ((RequestProtocol?, Data?, Error?) -> Void)?
    private let appContext: Context
    init(appContext: Context) {
        self.appContext = appContext
    }

    func run(_ request: RequestProtocol?) {
        guard let request = request else {
            completion?(nil, nil, nil)
            return
        }
        request.completion = { data, error in
            self.completion?(request, data, error)
        }

        do {
            try request.start()
        } catch {
            completion?(request, nil, error)
        }
    }
}
