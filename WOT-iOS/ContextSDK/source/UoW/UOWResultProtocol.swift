//
//  UOWResultProtocol.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWResultProtocol

@objc
public protocol UOWResultProtocol {
    var uow: UOWProtocol { get }
    var fetchResult: Any? { get }
    var error: Error? { get }
}

// MARK: - UOWResult

class UOWResult: UOWResultProtocol {
    public let uow: UOWProtocol
    public let fetchResult: Any?
    public let error: Error?

    // MARK: Lifecycle

    public required init(uow: UOWProtocol, fetchResult: Any?, error: Error?) {
        self.uow = uow
        self.fetchResult = fetchResult
        self.error = error
    }
}
