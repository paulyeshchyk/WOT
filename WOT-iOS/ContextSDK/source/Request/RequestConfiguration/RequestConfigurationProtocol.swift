//
//  RequestConfigurationProtocol.swift
//  ContextSDK
//
//  Created by Paul on 18.01.23.
//

// MARK: - RequestConfigurationProtocol

@objc
public protocol RequestConfigurationProtocol {

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    var modelClass: ModelClassType { get }
    var modelFieldKeyPaths: [String]? { get set }

    func buildArguments(forRequest: RequestProtocol?) throws -> RequestArgumentsProtocol
}
