//
//  AsyncBlockOperation.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

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
