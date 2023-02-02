//
//  DataAdapterProtocol.swift
//  ContextSDK
//
//  Created by Paul on 21.12.22.
//

// MARK: - ResponseAdapterProtocol

@objc
public protocol ResponseAdapterProtocol {

    typealias Context = LogInspectorContainerProtocol

    typealias OnComplete = (JSON?, Error?) -> Void

    var responseClass: AnyClass { get }
    var completion: ResponseAdapterProtocol.OnComplete? { get set }

    init(appContext: Context)

    func decode(data: Data?)
}

// MARK: - JSONAdapterProtocol

public protocol JSONAdapterProtocol: ResponseAdapterProtocol, MD5Protocol {}
