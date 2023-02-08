//
//  UOWManager.swift
//  ContextSDK
//
//  Created by Paul on 23.01.23.
//

import Combine

// MARK: - UOWManager

public class UOWManager: UOWManagerProtocol {

    private let workingQueue: DispatchQueue = DispatchQueue(label: "UOWManagerQueue", qos: .userInitiated)
    private let appContext: Context
    private let stateCollectionContainer = UOWStateCollectionContainer<String>()
    private var cancellables = Set<AnyCancellable>()

    public init(appContext: Context) {
        self.appContext = appContext

        stateCollectionContainer.deletionEventsPublisher
            .receive(on: workingQueue)
            .sink { value in
                let userInfo = try? value.serialized(type: [String: Any].self)
                NotificationCenter.default.post(name: .UOWDeleted, object: nil, userInfo: userInfo)
            }
            .store(in: &cancellables)
    }

    public func run(unit uow: UOWProtocol, inContextOfWork: UOWProtocol?, listenerCompletion: @escaping(ListenerCompletionType)) {
        //

        let oq = UOWOperationQueue(qualityOfService: .utility)
        oq.onAdd = { uowset in
            uowset.forEach { uow in
                self.stateCollectionContainer.addAndNotify(uow.MD5, parent: inContextOfWork?.MD5)
            }
        }
        oq.onRemove = { uow in
            self.stateCollectionContainer.removeAndNotify(uow.MD5)
        }
        oq.add(unit: uow) { result in
            self.workingQueue.async {
                self.stateCollectionContainer.removeAndNotify(result.uow.MD5)
                listenerCompletion(result)
            }
        }
    }

    public func run(units: [UOWProtocol], inContextOfWork: UOWProtocol?, listenerCompletion: @escaping(SequenceCompletionType)) {
        //
        let sequenceOperationQueue = UOWOperationQueue(qualityOfService: .utility)
        //
        sequenceOperationQueue.onAdd = { uowset in
            uowset.forEach { uow in
                self.stateCollectionContainer.addAndNotify(uow.MD5, parent: inContextOfWork?.MD5)
            }
        }
        sequenceOperationQueue.onRemove = { uow in
            self.stateCollectionContainer.removeAndNotify(uow.MD5)
        }

        sequenceOperationQueue.add(units: units) {
            self.workingQueue.async {
                listenerCompletion(nil)
            }
        }
    }
}

public extension NSNotification.Name {
    static let UOWDeleted = NSNotification.Name("UOWDeleted")
}

// MARK: - UOWManager.Errors

extension UOWManager {
    enum Errors: Error {
        case uowHasNoRunnableBlock
        case uowHasNoBlockForAsyncOperation
        case uowHasNoBlockForBlockOperation
    }
}
