//
//  UOWResultProtocol.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWResultProtocol

@objc
public protocol UOWResultProtocol {
    var fetchResult: Any? { get }
    var error: Error? { get }
    init(fetchResult: Any?, error: Error?)
}

// MARK: - UOWResult

class UOWResult: UOWResultProtocol {
    public let fetchResult: Any?
    public let error: Error?

    // MARK: Lifecycle

    public required init(fetchResult: Any?, error: Error?) {
        self.fetchResult = fetchResult
        self.error = error
    }
}
