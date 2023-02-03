//
//  UOWManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

public typealias ListenerCompletionType = ((UOWResultProtocol) -> Void)

public typealias SequenceCompletionType = ((Error?) -> Void)

// MARK: - UOWManagerContainerProtocol

@objc
public protocol UOWManagerContainerProtocol {
    var uowManager: UOWManagerProtocol { get }
}

// MARK: - UOWManagerProtocol

@objc
public protocol UOWManagerProtocol {
    typealias Context = LogInspectorContainerProtocol
        & UOWManagerContainerProtocol

    func run(unit uow: UOWProtocol, listenerCompletion: @escaping(ListenerCompletionType))

    func run(units: [UOWProtocol], listenerCompletion: @escaping(SequenceCompletionType))
}
