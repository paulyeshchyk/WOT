//
//  UOWOperationQueue.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWOperationQueueProtocol

protocol UOWOperationQueueProtocol {
    init(qualityOfService: QualityOfService)
    func add(units sequence: [UOWProtocol])
    func add(unit uow: UOWProtocol)
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
    var onSequenceCompletion: (() -> Void)?
    var onUnitCompletion: ((UOWResultProtocol) -> Void)?

    required convenience init(qualityOfService: QualityOfService) {
        self.init()
        self.qualityOfService = qualityOfService
    }

    func add(units sequence: [UOWProtocol]) {
        //
        let sequenceProgress = UOWOperationSequenceProgress()
        sequenceProgress.onSequenceCompletion = onSequenceCompletion

        let set = sequence.compactMap {
            return try? ($0 as? UOWRunnable)?.blockOperation { result in

                self.onRemove?(result.uow)

                sequenceProgress.increaseDone(by: 1)
            }
        }

        onAdd?(sequence)

        sequenceProgress.increaseTobeDone(by: (set.count))
        super.addOperations(set, waitUntilFinished: false)
    }

    func add(unit uow: UOWProtocol) {
        //
        do {
            guard let runnable = uow as? UOWRunnable else {
                throw UOWOperationQueueErrors.uowIsNotRunnable
            }
            onAdd?([uow])
            let op = try runnable.blockOperation { obj in
                self.onRemove?(obj.uow)
                self.onUnitCompletion?(obj)
            }
            super.addOperation(op)
        } catch {
            onUnitCompletion?(UOWResult(uow: uow, fetchResult: nil, error: error))
        }
    }
}

// MARK: - %t + UOWOperationQueue.UOWOperationQueueErrors

extension UOWOperationQueue {
    enum UOWOperationQueueErrors: Error {
        case uowIsNotRunnable
    }
}
