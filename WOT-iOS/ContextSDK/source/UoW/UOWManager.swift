//
//  UOWManager.swift
//  ContextSDK
//
//  Created by Paul on 23.01.23.
//

// MARK: - UOWManager

public class UOWManager: UOWManagerProtocol {

    private let workingQueue: DispatchQueue = DispatchQueue(label: "UOWManagerQueue", qos: .userInitiated)
    private let appContext: Context

    public init(appContext: Context) {
        self.appContext = appContext
    }

    public func run(unit uow: UOWProtocol, listenerCompletion: @escaping(ListenerCompletionType)) {
        //
        let oq = UOWOperationQueue(qualityOfService: .utility)
        oq.add(unit: uow) { obj in
            self.workingQueue.async {
                listenerCompletion(obj)
            }
        }
    }

    public func run(units: [UOWProtocol], listenerCompletion: @escaping(SequenceCompletionType)) {
        //
        let sequenceOperationQueue = UOWOperationQueue(qualityOfService: .utility)
        sequenceOperationQueue.add(units: units) {
            self.workingQueue.async {
                listenerCompletion(nil)
            }
        }
    }
}

// MARK: - %t + UOWManager.Errors

extension UOWManager {
    enum Errors: Error {
        case uowHasNoRunnableBlock
        case uowHasNoBlockForAsyncOperation
        case uowHasNoBlockForBlockOperation
    }
}
