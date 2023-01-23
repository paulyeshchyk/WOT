//
//  UOWManager.swift
//  ContextSDK
//
//  Created by Paul on 23.01.23.
//

// MARK: - UOWManagerContainerProtocol

@objc
public protocol UOWManagerContainerProtocol {
    var uowManager: UOWManagerProtocol { get }
}

// MARK: - UOWType

@objc
public enum UOWType: Int {
    case decodeAndLink
}

// MARK: - UOWProtocol

@objc
public protocol UOWProtocol: MD5Protocol {
    var uowType: UOWType { get }
}

// MARK: - UOWResultProtocol

public protocol UOWResultProtocol {
    var fetchResult: Any? { get }
    var error: Error? { get }
    init(fetchResult: Any?, error: Error?)
}

// MARK: - UOWRunnable

public typealias ListenerCompletionType = ((Any) -> Void)

// MARK: - UOWRunnable

protocol UOWRunnable {
    typealias RunnableExitType = (@escaping ListenerCompletionType, UOWResultProtocol) -> Void
    typealias RunnableBlockType = (_ exitToPassThrough: @escaping ListenerCompletionType, _ exit: @escaping RunnableExitType) -> Void
    func runnableBlock() -> RunnableBlockType?
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

    typealias ModelClassType = (PrimaryKeypathProtocol & FetchableProtocol).Type

    func run(_ uow: UOWProtocol, listenerCompletion: @escaping(ListenerCompletionType)) throws
}

// MARK: - UOWManager

public class UOWManager: UOWManagerProtocol {

    private let appContext: Context
    public init(appContext: Context) {
        self.appContext = appContext
    }

    public func run(_ uow: UOWProtocol, listenerCompletion: @escaping(ListenerCompletionType)) throws {
        guard let runnable = uow as? UOWRunnable else {
            throw Errors.uowIsNotRunnable
        }

        guard let block = runnable.block(forCompletion: listenerCompletion) else {
            throw Errors.uowHasNoRunnableBlock
        }
        block()
    }
}

extension UOWRunnable {

    /**
     ~~~
     // sample:
         guard let block = runnable.block(forCompletion: listenerCompletion) else {
             throw Errors.uowHasNoRunnableBlock
         }
         block()
     ~~~
     */

    func block(forCompletion: @escaping(ListenerCompletionType)) -> (() -> Void)? {
        guard let runnableBlock = runnableBlock() else {
            return nil
        }

        return {
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
            }
        }
    }

    /**
     ~~~
     // sample:
         guard let op = runnable.serialQueueOperation(forCompletion: listenerCompletion) else {
             throw Errors.uowIsNotRunnable
         }
         oq.addOperation(op)
     ~~~
     */

    func serialQueueOperation(forCompletion: @escaping(ListenerCompletionType)) -> Operation? {
        guard let runnableBlock = runnableBlock() else { return nil }
        return BlockOperation {
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
            }
        }
    }

    /**
     ~~~
     // sample:
     guard let op = runnable.asyncOperation(forCompletion: listenerCompletion) else {
             throw Errors.uowIsNotRunnable
         }
         oq.addOperation(op)
     ~~~
     */
    func asyncOperation(forCompletion: @escaping(ListenerCompletionType)) -> Operation? {
        guard let runnableBlock = runnableBlock() else { return nil }
        return AsyncBlockOperation { ch in
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
                ch()
            }
        }
    }
}

// MARK: - UOWManager.Errors

extension UOWManager {
    
    enum Errors: Error {
        case uowIsNotRunnable
        case uowHasNoRunnableBlock
    }
}
