//
//  ConcurrentOperation.swift
//  ContextSDK
//
//  Copyright https://eon.codes/blog/2021/06/10/NSOperationQueue-in-swift/
//

// MARK: - ConcurrentOperation

public class ConcurrentOperation: Operation {
    override public var isExecuting: Bool {
        get { backing_executing }
        set {
            willChangeValue(forKey: "isExecuting")
            backing_executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    override public var isFinished: Bool {
        get { backing_finished }
        set {
            willChangeValue(forKey: "isFinished")
            backing_finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    private var backing_executing: Bool
    private var backing_finished: Bool

    // MARK: Lifecycle

    override public init() {
        backing_executing = false
        backing_finished = false
        super.init()
    }

    // MARK: Internal

    func completeOperation() {
        isExecuting = false
        isFinished = true
    }
}

/*
 /*
  nice to have
  */
    class TestOperation: ConcurrentOperation {

        override func main() {
            guard canGoFurtherOrComplete() else { return }
            // ...
        }

        private func canGoFurtherOrComplete() -> Bool {
            if isCancelled {
                // error = ConcurrentOperationError.canceled
                completeOperation()
            }
            return !isCancelled
        }
    }

 // MARK: - ConcurrentOperationError

 public enum ConcurrentOperationError: Error, CustomStringConvertible {
     case canceled

     public var description: String {
         switch self {
         case .canceled: return "\(type(of: self)) is canceled"
         }
     }
 }

 */
