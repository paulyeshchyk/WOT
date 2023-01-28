//
//  UOWManagerProtocol.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

public typealias ListenerCompletionType = ((Any) -> Void)

/// returns count of successfully executed runs
/// and errors set
public typealias SequenceCompletionType = ((Int, Error?) -> Void)

// MARK: - UOWManagerContainerProtocol

@objc
public protocol UOWManagerContainerProtocol {
    var uowManager: UOWManagerProtocol { get }
}

// MARK: - UOWManagerProtocol

@objc
public protocol UOWManagerProtocol {
    typealias Context = LogInspectorContainerProtocol
        & DataStoreContainerProtocol
        & DecoderManagerContainerProtocol
        & RequestManagerContainerProtocol
        & RequestRegistratorContainerProtocol
        & UOWManagerContainerProtocol

    func run(_ uow: UOWProtocol, listenerCompletion: @escaping(ListenerCompletionType)) throws

    func run(sequence: [UOWProtocol], listenerCompletion: @escaping(SequenceCompletionType)) throws
}
