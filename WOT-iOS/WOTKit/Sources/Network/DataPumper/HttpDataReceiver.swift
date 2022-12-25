//
//  WOTWebDataPumper.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/17/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

public class HttpDataReceiver: HttpDataReceiverProtocol, CustomStringConvertible {
    enum WOTWebDataPumperError: Error {
        case urlNotDefined
    }

    let request: URLRequest

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }
    
    public var description: String { "\(type(of: self)): \(String(describing: request))" }
    
    public weak var delegate: HttpDataReceiverDelegateProtocol?
    
    private let context: HttpDataReceiverProtocol.Context
    required public init(context: HttpDataReceiverProtocol.Context, request: URLRequest) {
        self.request = request
        self.context = context
    }

    public func start() {
        guard let url = request.url else {
            delegate?.didEnd(urlRequest: request, receiver: self, data: nil, error: WOTWebDataPumperError.urlNotDefined)
            return
        }
        
        delegate?.didStart(urlRequest: request, receiver: self)
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            DispatchQueue.main.async { 
                self.delegate?.didEnd(urlRequest: self.request, receiver: self, data: data, error: error)
            }

        }.resume()
    }
}
