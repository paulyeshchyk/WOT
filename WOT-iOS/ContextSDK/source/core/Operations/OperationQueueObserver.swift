//
//  OperationQueueObserver.swift
//  ContextSDK
//
//  Created by Paul on 8.01.23.
//

/*
 // sample
 func testObserver() {
     let operationQueue: OperationQueue = ...
     operationQueue.addOperations([operation1, operation2,...])

     let operationQueueObserver = OperationQueueObserver(completion: { value in
         if let intValue = value as? Int {
             if intValue == 0 {
                 // all operations finished here
             }
         }
     })
     observer.observeQueue(operationQueue)
 }
 */

private class OperationQueueObserver: NSObject {

    private let completion: (Any?) -> Void

    // MARK: Lifecycle

    required init(completion: @escaping (Any?) -> Void) {
        self.completion = completion
        super.init()
    }

    // MARK: Internal

    func observeQueue(_ queue: OperationQueue) {
        queue.addObserver(self, forKeyPath: #keyPath(OperationQueue.operationCount), options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of _: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(OperationQueue.operationCount):
            completion(change?[.newKey])
        default: break
        }
    }
}
