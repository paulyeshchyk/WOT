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

        stateCollectionContainer.progressEventsPublisher
            .receive(on: workingQueue)
            .sink { value in
                let userInfo = try? value.serialized(type: [String: Any].self)
                NotificationCenter.default.post(name: .UOWProgress, object: nil, userInfo: userInfo)
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
        oq.onUnitCompletion = { result in
            self.stateCollectionContainer.removeAndNotify(result.uow.MD5)
            listenerCompletion(result)
        }
        //
        oq.add(unit: uow)
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
        sequenceOperationQueue.onUnitCompletion = { result in
            self.stateCollectionContainer.removeAndNotify(result.uow.MD5)
        }
        sequenceOperationQueue.onSequenceCompletion = {
            self.workingQueue.async {
                listenerCompletion(nil)
            }
        }
        //
        sequenceOperationQueue.add(units: units)
    }
}

public extension NSNotification.Name {
    static let UOWProgress = NSNotification.Name("UOWProgress")
}

// MARK: - UOWManager.Errors

extension UOWManager {
    enum Errors: Error {
        case uowHasNoRunnableBlock
        case uowHasNoBlockForAsyncOperation
        case uowHasNoBlockForBlockOperation
    }
}
