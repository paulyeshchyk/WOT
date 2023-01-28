//
//  UOWManager.swift
//  ContextSDK
//
//  Created by Paul on 23.01.23.
//

// MARK: - UOWManager

public class UOWManager: UOWManagerProtocol {

    private let workingQueue: DispatchQueue = DispatchQueue(label: "UOWManagerQueue", qos: .userInitiated)
    private let appContext: Context
    public init(appContext: Context) {
        self.appContext = appContext
    }

    public func run(_ uow: UOWProtocol, listenerCompletion: @escaping(ListenerCompletionType)) throws {
        guard let runnable = uow as? UOWRunnable else {
            throw Errors.uowIsNotRunnable
        }

        let oq = UOWOperationQueue()
        let op = try runnable.blockOperation { obj in
            self.workingQueue.async {
                listenerCompletion(obj)
            }
        }
        oq.addOperation(op)
    }

    public func run(sequence: [UOWProtocol], listenerCompletion: @escaping(SequenceCompletionType)) throws {
        //

        let progress = UOWOperationsProgress()
        var completed: Bool = false
        let set = sequence.compactMap {
            return try? ($0 as? UOWRunnable)?.blockOperation { _ in
                progress.increaseDone(by: 1) { isInProgress in
                    if completed {
                        assertionFailure("should not be here")
                    }

                    if !isInProgress {
                        self.workingQueue.async {
                            listenerCompletion(0, nil)
                        }
                        completed = true
                    }
                }
            }
        }

        progress.increaseTobeDone(by: (set.count))

        let sequenceOperationQueue = UOWOperationQueue()
        sequenceOperationQueue.addOperations(set, waitUntilFinished: false)
    }
}

// MARK: - %t + UOWManager.Errors

extension UOWManager {
    enum Errors: Error {
        case uowIsNotRunnable
        case uowHasNoRunnableBlock
        case uowHasNoBlockForAsyncOperation
        case uowHasNoBlockForBlockOperation
    }
}
