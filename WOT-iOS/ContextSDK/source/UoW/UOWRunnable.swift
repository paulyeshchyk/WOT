//
//  UOWRunnable.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWResultProtocol

public protocol UOWResultProtocol {
    var fetchResult: Any? { get }
    var error: Error? { get }
    init(fetchResult: Any?, error: Error?)
}

// MARK: - UOWRunnable

protocol UOWRunnable {
    typealias RunnableExitType = (@escaping ListenerCompletionType, UOWResultProtocol) -> Void
    typealias RunnableBlockType = (_ exitToPassThrough: @escaping ListenerCompletionType, _ exit: @escaping RunnableExitType) -> Void
    func runnableBlock() -> RunnableBlockType?
}

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
