//
//  UOWOperationQueue.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWOperationQueueProtocol

protocol UOWOperationQueueProtocol {
    init(qualityOfService: QualityOfService)
    func add(units sequence: [UOWProtocol], completion: @escaping(() -> Void))
    func add(unit uow: UOWProtocol, completion: @escaping((UOWResultProtocol) -> Void))
}

// MARK: - UOWOperationQueue

class UOWOperationQueue: OperationQueue, UOWOperationQueueProtocol {

    @available(*, unavailable)
    override func addOperations(_ ops: [Operation], waitUntilFinished wait: Bool) {
        super.addOperations(ops, waitUntilFinished: wait)
    }

    @available(*, unavailable)
    override func addOperation(_ op: Operation) {
        super.addOperation(op)
    }

    @available(iOS, introduced: 13.0, unavailable)
    override func addBarrierBlock(_ barrier: @escaping () -> Void) {
        super.addBarrierBlock(barrier)
    }

    var onAdd: (([UOWProtocol]) -> Void)?
    var onRemove: ((UOWProtocol) -> Void)?

    required convenience init(qualityOfService: QualityOfService) {
        self.init()
        self.qualityOfService = qualityOfService
    }

    func add(units sequence: [UOWProtocol], completion: @escaping(() -> Void)) {
        //
        let progress = UOWOperationsProgress()
        var completed: Bool = false

        let set = sequence.compactMap {
            return try? ($0 as? UOWRunnable)?.blockOperation { result in

                self.onRemove?(result.uow)

                progress.increaseDone(by: 1) { isInProgress in
                    if completed {
                        assertionFailure("should not be here")
                    }

                    if !isInProgress {
                        completion()
                        completed = true
                    }
                }
            }
        }

        onAdd?(sequence)

        progress.increaseTobeDone(by: (set.count))
        super.addOperations(set, waitUntilFinished: false)
    }

    func add(unit uow: UOWProtocol, completion: @escaping((UOWResultProtocol) -> Void)) {
        //
        do {
            guard let runnable = uow as? UOWRunnable else {
                throw UOWOperationQueueErrors.uowIsNotRunnable
            }
            onAdd?([uow])
            let op = try runnable.blockOperation { obj in
                self.onRemove?(obj.uow)
                completion(obj)
            }
            super.addOperation(op)
        } catch {
            completion(UOWResult(uow: uow, fetchResult: nil, error: error))
        }
    }
}

// MARK: - %t + UOWOperationQueue.UOWOperationQueueErrors

extension UOWOperationQueue {
    enum UOWOperationQueueErrors: Error {
        case uowIsNotRunnable
    }
}
