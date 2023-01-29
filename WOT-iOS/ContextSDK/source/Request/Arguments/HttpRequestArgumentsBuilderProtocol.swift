//
//  HttpRequestArgumentsBuilderProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

// MARK: - RequestArgumentsBuilderProtocol

@objc
public protocol RequestArgumentsBuilderProtocol: MD5Protocol {
    func build() -> RequestArgumentsProtocol
}

// MARK: - HttpRequestArgumentsBuilderProtocol

@objc
public protocol HttpRequestArgumentsBuilderProtocol: RequestArgumentsBuilderProtocol {

    var keyPaths: [String]? { get set }
    var contextPredicate: ContextPredicateProtocol? { get set }
    var keypathPrefix: String? { get set }
    var httpQueryItemName: String? { get set }

}
