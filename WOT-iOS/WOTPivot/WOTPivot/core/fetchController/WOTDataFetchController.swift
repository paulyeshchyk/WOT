//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData

open class WOTDataFetchController: NSObject {

    lazy fileprivate var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let context = self.dataProvider.mainManagedObjectContext
        let request = self.nodeFetchRequestCreator.fetchRequest
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        return result
    }()

    public var listener: WOTDataFetchControllerListenerProtocol?
    public var nodeFetchRequestCreator: WOTDataFetchControllerDelegateProtocol
    public var dataProvider: WOTCoredataProviderProtocol

    @objc
    public init(nodeFetchRequestCreator nfrc: WOTDataFetchControllerDelegateProtocol, dataprovider: WOTCoredataProviderProtocol) {
        nodeFetchRequestCreator = nfrc
        dataProvider = dataprovider
    }

    deinit {
        self.fetchResultController.delegate = nil
    }
}

extension WOTDataFetchController: WOTDataFetchControllerProtocol {

    public func performFetch(nodeCreator: WOTNodeCreatorProtocol?) throws {
        self.fetchResultController.managedObjectContext.perform({
            do {
                try self.fetchResultController.performFetch()
                self.listener?.fetchPerformed(by: self)
            } catch let error {
                self.listener?.fetchFailed(by: self, withError: error)
            }
        })
    }

    public func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    public func fetchedObjects() -> [AnyObject]? {
        return self.fetchResultController.fetchedObjects
    }

    open func fetchedNodes(byPredicates: [NSPredicate], nodeCreator: WOTNodeCreatorProtocol?, filteredCompletion: (NSPredicate, [AnyObject]?) -> Void) {

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        let filtered = (self.fetchedObjects()?.filter { predicate.evaluate(with: $0) })
        filteredCompletion(predicate,filtered)
    }
}

extension WOTDataFetchController: NSFetchedResultsControllerDelegate {

    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }

    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }

    private func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }

    private func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }

    private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
}
