//
//  WOTDataFetchController+NodeCreator.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import WOTKit

extension WOTDataFetchController: WOTDataFetchControllerProtocol {
    public func performFetch(nodeCreator: WOTNodeCreatorProtocol?) throws {
        if let fetch = self.fetchResultController {
            try performFetch(with: fetch, nodeCreator: nodeCreator)
        } else {
            try initFetchController { fetch in
                self.fetchResultController = fetch
                try? self.performFetch(with: fetch, nodeCreator: nodeCreator)
            }
        }
    }

    private func performFetch(with fetchResultController: WOTDataFetchedResultController, nodeCreator: WOTNodeCreatorProtocol? ) throws {
        do {
            try fetchResultController.performFetch()
            self.listener?.fetchPerformed(by: self)
        } catch let error {
            self.listener?.fetchFailed(by: self, withError: error)
        }
    }

    public func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    public func fetchedObjects() -> [AnyObject]? {
        return self.fetchResultController?.fetchedObjects
    }

    open func fetchedNodes(byPredicates: [NSPredicate], nodeCreator: WOTNodeCreatorProtocol?, filteredCompletion: FilteredObjectCompletion) {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        let filtered = (self.fetchedObjects()?.filter { predicate.evaluate(with: $0) })
        filteredCompletion(predicate, filtered)
    }
}
