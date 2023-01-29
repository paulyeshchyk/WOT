//
//  AsyncOperation.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

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
