//
//  RequestConfigurationProtocol.swift
//  ContextSDK
//
//  Created by Paul on 18.01.23.
//

// MARK: - RequestConfigurationProtocol

@objc
public protocol RequestConfigurationProtocol {

    var modelClass: ModelClassType { get }
    var modelFieldKeyPaths: [String]? { get set }

    func buildArguments(forRequest: RequestProtocol?) throws -> RequestArgumentsProtocol
}
