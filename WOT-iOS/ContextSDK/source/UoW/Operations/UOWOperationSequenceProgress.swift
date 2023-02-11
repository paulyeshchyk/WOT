//
//  UOWOperationSequenceProgress.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWProgress

class UOWOperationSequenceProgress {

    var onSequenceCompletion: (() -> Void)?
    private let progressQueue = DispatchQueue(label: "UOWOperationsProgressQueue")
    private var toBeDoneCount: Int = 0
    private var doneCount: Int = 0

    // to be used with backgroundQueue
    private func getResult() -> Double {
        guard toBeDoneCount != 0 else { return 1 }
        guard doneCount != 0 else { return 0 }
        guard toBeDoneCount != doneCount else {
            toBeDoneCount = 0
            doneCount = 0
            return 1
        }
        return Double(doneCount) / Double(toBeDoneCount)
    }

    func checkIsInProgress(completion: (Bool) -> Void) {
        progressQueue.sync {
            let result = toBeDoneCount != doneCount
            completion(result)
        }
    }

    func increaseTobeDone(by: Int = 1) {
        progressQueue.sync {
            toBeDoneCount += by
        }
    }

    func increaseDone(by: Int = 1) {
        progressQueue.sync {
            doneCount += by
            if toBeDoneCount == doneCount {
                onSequenceCompletion?()
            }
        }
    }
}
