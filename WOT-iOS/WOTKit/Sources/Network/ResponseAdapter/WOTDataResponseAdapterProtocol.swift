//
//  WOTDataResponseAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

public typealias WOTRequestIdType = String

@objc
public protocol WOTDataResponseAdapterProtocol: NSObjectProtocol {

    var logInspector: LogInspectorProtocol? { get set }
    var coreDataStore: WOTCoredataStoreProtocol? { get set }

    init(clazz: PrimaryKeypathProtocol.Type)

    func request(_ request: WOTRequestProtocol, parseData binary: Data?, linker: JSONAdapterLinkerProtocol, decoderAndMapper: WOTDecodeAndMappingProtocol, onRequestComplete: @escaping OnRequestComplete ) -> JSONAdapterProtocol
}
