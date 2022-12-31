//
//  WOTDataFetchController+NodeCreator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTKit

extension WOTDataFetchController: WOTDataFetchControllerProtocol {
    public func performFetch(nodeCreator: WOTNodeCreatorProtocol?) throws {
        if let fetch = fetchResultController {
            try performFetch(with: fetch, nodeCreator: nodeCreator)
        } else {
            try initFetchController {[weak self] fetchResultController, error in
                if let err = error {
                    self?.appContext.logInspector?.logEvent(EventError(err, details: nil), sender: self)
                } else {
                    self?.fetchResultController = fetchResultController
                    do {
                        try self?.performFetch(with: fetchResultController, nodeCreator: nodeCreator)
                    } catch {
                        self?.appContext.logInspector?.logEvent(EventError(error, details: nil), sender: self)
                    }
                }
            }
        }
    }

    private func performFetch(with: WOTDataFetchedResultController?, nodeCreator _: WOTNodeCreatorProtocol?) throws {
        guard let fetchResultController = with else {
            throw DataFetchControllerError.noFetchResultControllerCreated
        }
        do {
            try fetchResultController.performFetch()
            listener?.fetchPerformed(by: self)
        } catch let error {
            self.listener?.fetchFailed(by: self, withError: error)
        }
        fetchResultController.delegate = nil
    }

    public func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    public func fetchedObjects() -> [AnyObject]? {
        return fetchResultController?.fetchedObjects
    }

    open func fetchedNodes(byPredicates: [NSPredicate], nodeCreator _: WOTNodeCreatorProtocol?, filteredCompletion: FilteredObjectCompletion) {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        let filtered = (fetchedObjects()?.filter { predicate.evaluate(with: $0) })
        filteredCompletion(predicate, filtered)
    }
}
