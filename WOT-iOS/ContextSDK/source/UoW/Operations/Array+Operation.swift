//
//  Array+Operation.swift
//  ContextSDK
//
//  Copyright https://medium.com/ios-os-x-development/code-at-the-end-of-the-queue-a1f7a94257d0
//

extension Array where Element: Operation {
    /// Execute block after all operations from the array.
    func onFinish(_ block: @escaping () -> Void) {
        let doneOperation = BlockOperation(block: block)
        forEach { [unowned doneOperation] in doneOperation.addDependency($0) }
        OperationQueue().addOperation(doneOperation)
    }
}
