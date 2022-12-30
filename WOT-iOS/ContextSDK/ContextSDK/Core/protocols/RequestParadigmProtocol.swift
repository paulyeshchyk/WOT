//
//  RequestParadigmProtocol.swift
//  ContextSDK
//
//  Created by Paul on 30.12.22.
//

@objc
public protocol RequestParadigmProtocol: MD5Protocol {
    var modelClass: AnyClass { get }
    func buildRequestArguments() -> RequestArguments
}
