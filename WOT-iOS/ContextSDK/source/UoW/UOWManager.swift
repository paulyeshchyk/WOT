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

/// returns count of successfully executed runs
/// and errors set
public typealias SequenceCompletionType = ((Int, Error?) -> Void)

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

    func run(sequence: [UOWProtocol], listenerCompletion: @escaping(SequenceCompletionType)) throws
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

        let oq = UOWOperationQueue()
        let op = try runnable.blockOperation(forCompletion: listenerCompletion)
        oq.addOperation(op)
    }

    var observation: NSKeyValueObservation?
    public func run(sequence: [UOWProtocol], listenerCompletion: @escaping(SequenceCompletionType)) throws {
        //
        let set = sequence.compactMap {
            return try? ($0 as? UOWRunnable)?.blockOperation { _ in
                //
            }
        }
        let sequenceOperationQueue = UOWOperationQueue()
        sequenceOperationQueue.addOperations(set, waitUntilFinished: false)
        observation = sequenceOperationQueue.observe(\.operationCount) { operationQueue, _ in
            if operationQueue.operationCount == 0 {
                listenerCompletion(0, nil)
                self.observation = nil
            }
        }
    }
}

// MARK: - UOWOperationQueue

class UOWOperationQueue: OperationQueue {}

extension UOWRunnable {

    /**
     ~~~
        // sample:
        let block = try runnable.block(forCompletion: listenerCompletion)
        block()
     ~~~
     */

    func block(forCompletion: @escaping(ListenerCompletionType)) throws -> (() -> Void) {
        guard let runnableBlock = runnableBlock() else { throw UOWManager.Errors.uowHasNoRunnableBlock }

        return {
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
            }
        }
    }

    /**
     ~~~
        // sample:
        let op = try runnable.syncOperation(forCompletion: listenerCompletion)
        oq.addOperation(op)
     ~~~
     */

    func blockOperation(forCompletion: @escaping(ListenerCompletionType)) throws -> Operation {
        guard let runnableBlock = runnableBlock() else { throw UOWManager.Errors.uowHasNoBlockForBlockOperation }
        return BlockOperation {
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
            }
        }
    }

    /**
     ~~~
        // sample:
        let op = try runnable.asyncOperation(forCompletion: listenerCompletion)
        oq.addOperation(op)
     ~~~
     */
    func asyncOperation(forCompletion: @escaping(ListenerCompletionType)) throws -> Operation {
        guard let runnableBlock = runnableBlock() else { throw UOWManager.Errors.uowHasNoBlockForAsyncOperation }
        return AsyncBlockOperation { ch in
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
                ch()
            }
        }
    }

    /**
     ~~~
        // sample:
        let op = try runnable.concurrentOperation(forCompletion: listenerCompletion)
        oq.addOperation(op)
     ~~~
     */
    func concurrentOperation(forCompletion: @escaping(ListenerCompletionType)) throws -> Operation {
        guard let runnableBlock = runnableBlock() else { throw UOWManager.Errors.uowHasNoBlockForAsyncOperation }
        return ConcurrentBlockOperation {
            runnableBlock(forCompletion) { escapedListenerCompletion, result in
                escapedListenerCompletion(result)
            }
        }
    }
}

// MARK: - UOWManager.Errors

extension UOWManager {
    enum Errors: Error {
        case uowIsNotRunnable
        case uowHasNoRunnableBlock
        case uowHasNoBlockForAsyncOperation
        case uowHasNoBlockForBlockOperation
    }
}
