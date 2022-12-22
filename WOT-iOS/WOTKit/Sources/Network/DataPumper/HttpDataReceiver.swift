//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

class HttpDataReceiver: NSObject, HttpDataReceiverProtocol {
    enum WOTWebDataPumperError: Error {
        case urlNotDefined
    }

    let request: URLRequest

    override var hash: Int {
        return request.url?.absoluteString.hashValue ?? 0
    }

    override var description: String {
        return request.url?.absoluteString ?? "-"
    }
    
    public weak var delegate: HttpDataReceiverDelegateProtocol?
    
    private let context: HttpDataReceiverProtocol.Context
    required init(context: HttpDataReceiverProtocol.Context, request: URLRequest) {
        self.request = request
        self.context = context

        super.init()
    }

    public func start() {
        guard let url = request.url else {
            delegate?.didEnd(receiver: self, data: nil, error: WOTWebDataPumperError.urlNotDefined)
            return
        }
        
        delegate?.didStart(receiver: self)
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            DispatchQueue.main.async { 
                self.delegate?.didEnd(receiver: self, data: data, error: error)
            }

        }.resume()
    }
}
