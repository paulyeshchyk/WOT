//
//  ConcurrentBlockOperation.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - ConcurrentBlockOperation

public class ConcurrentBlockOperation: ConcurrentOperation {
    private let closure: () -> Void

    // MARK: Lifecycle

    public init(closure: @escaping () -> Void) {
        self.closure = closure
        super.init()
    }

    // MARK: Open

    override open func main() {
        super.main()
        closure()
    }

}
