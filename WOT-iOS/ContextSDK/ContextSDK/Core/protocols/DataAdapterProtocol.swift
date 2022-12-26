//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

@objc
public protocol DataAdapterProtocol {
    typealias OnComplete = (RequestProtocol, Error?) -> Void

}
