//
//  UOWOperationQueue.swift
//  ContextSDK
//
//  Created by Paul on 28.01.23.
//

// MARK: - UOWOperationQueue

class UOWOperationQueue: OperationQueue {
    override init() {
        super.init()
        qualityOfService = .background
    }
}
