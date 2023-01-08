//
//  ConcurrentOperation.swift
//  ContextSDK
//
//  Copyright https://eon.codes/blog/2021/06/10/NSOperationQueue-in-swift/
//

// MARK: - ConcurrentOperation

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
 */

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

// MARK: - ConcurrentOperationError

public enum ConcurrentOperationError: Error, CustomStringConvertible {
    case canceled

    public var description: String {
        switch self {
        case .canceled: return "\(type(of: self)) is canceled"
        }
    }
}

// MARK: - AsyncOperation

open class AsyncOperation: Operation {
    override open var isAsynchronous: Bool { true }
    override open var isExecuting: Bool { self.state == .started }
    override open var isFinished: Bool { state == .done }

    private enum State {
        case initial
        case started
        case done
    }

    private var state: State = .initial {
        willSet { // due to a legacy issue, these have to be strings. Don't make them key paths.
            willChangeValue(forKey: "isExecuting")
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
            didChangeValue(forKey: "isExecuting")
        }
    }

    // MARK: Lifecycle

    public init(name: String? = nil) {
        super.init()
        if #available(macOS 10.10, *) {
            self.name = name
        }
    }

    // MARK: Open

    open func main(completionHandler _: @escaping () -> Void) {
        fatalError("Subclass must override main(completionHandler:)")
    }

    // MARK: Public

    override final public func start() {
        state = .started
        main {
            if case .done = self.state {
                fatalError("AsyncOperation completion block called twice")
            }
            self.state = .done
        }
    }

    override final public func main() {}

}

// MARK: - AsyncBlockOperation

open class AsyncBlockOperation: AsyncOperation {
    private let closure: (_ completionHandler: @escaping () -> Void) -> Void

    // MARK: Lifecycle

    public init(name: String? = nil, closure: @escaping (_ completionHandler: @escaping () -> Void) -> Void) {
        self.closure = closure
        super.init(name: name)
    }

    // MARK: Open

    override open func main(completionHandler: @escaping () -> Void) {
        closure(completionHandler)
    }

}
