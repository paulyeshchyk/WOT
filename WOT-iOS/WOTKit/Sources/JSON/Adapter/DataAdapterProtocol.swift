//
//  DataAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK

@objc
public protocol DataAdapterProtocol {
    var uuid: UUID { get }
    var onJSONDidParse: OnParseComplete? { get set }
    func didFinishJSONDecoding(_ json: JSON?, fromRequest: RequestProtocol, _ error: Error?)
}
