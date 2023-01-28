//
//  UOWProgress.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWProgress

class UOWOperationsProgress {

    var onValueChanged: ((Double) -> Void)?
    private let backgroundQueue = DispatchQueue.init(label: "progressQueue")
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
        backgroundQueue.sync {
            let result = toBeDoneCount != doneCount
            completion(result)
        }
    }

    func increaseTobeDone(by: Int = 1) {
        backgroundQueue.sync {
            toBeDoneCount += by
            let result = getResult()
            onValueChanged?(result)
        }
    }

    func increaseDone(by: Int = 1, isInProgressCompletion: ((Bool) -> Void)? = nil) {
        backgroundQueue.sync {
            doneCount += by

            let isInProgress = toBeDoneCount != doneCount
            isInProgressCompletion?(isInProgress)

            let result = getResult()
            onValueChanged?(result)
        }
    }
}
