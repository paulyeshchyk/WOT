//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

public typealias FilteredObjectCompletion = (NSPredicate, [AnyObject]?) -> Void

open class WOTDataFetchController: NSObject {
    typealias WOTDataFetchedResultController = NSFetchedResultsController<NSFetchRequestResult>

    private var fetchResultController: WOTDataFetchedResultController?

    private func initFetchController( block: @escaping (WOTDataFetchedResultController) -> Void ) throws {
        self.dataProvider?.performMain({ context in

            let request = self.nodeFetchRequestCreator.fetchRequest
            guard let result = self.dataProvider?.fetchResultController(for: request, andContext: context) else {
                fatalError("no FetchResultController created")
            }
            result.delegate = self
            block(result)
        })
    }

    public var listener: WOTDataFetchControllerListenerProtocol?
    public var nodeFetchRequestCreator: WOTDataFetchControllerDelegateProtocol
    public var dataProvider: WOTCoredataStoreProtocol?

    @objc
    required public init(nodeFetchRequestCreator nfrc: WOTDataFetchControllerDelegateProtocol, dataprovider: WOTCoredataStoreProtocol?) {
        nodeFetchRequestCreator = nfrc
        dataProvider = dataprovider
    }

    deinit {
        self.fetchResultController?.delegate = nil
    }
}

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

extension WOTDataFetchController: NSFetchedResultsControllerDelegate {
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {}

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
}
