//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

class WOTDataTanksFetchController: NSObject {

    lazy fileprivate var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>? = {
        guard let context = WOTCoreDataProvider.sharedInstance().mainManagedObjectContext else {
            return nil
        }
        let request = self.nodeFetchRequestCreator.fetchRequest
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        return result
    }()

    var listener: WOTDataFetchControllerListenerProtocol?
    var nodeFetchRequestCreator: WOTDataFetchControllerDelegateProtocol
    var nodeCreator: WOTNodeCreatorProtocol

    init(nodeFetchRequestCreator nfrc: WOTDataFetchControllerDelegateProtocol, nodeCreator nc: WOTNodeCreatorProtocol) {
        nodeFetchRequestCreator = nfrc
        nodeCreator = nc
    }

    deinit {
        self.fetchResultController?.delegate = nil
    }
}

extension WOTDataTanksFetchController: WOTDataFetchControllerProtocol {
    func performFetch() {
        self.fetchResultController?.managedObjectContext.perform({
            do {
                try self.fetchResultController?.performFetch()
                OperationQueue.main.addOperation {
                    self.listener?.fetchPerformed(by: self)
                }
            } catch let error {
                self.listener?.fetchFailed(by: self, withError: error)
            }
        })
    }

    func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    func fetchedObjects() -> [AnyObject]? {
        return self.fetchResultController?.fetchedObjects
    }

    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol] {

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        var result = [WOTNodeProtocol]()

        guard let filtered = (self.fetchedObjects()?.filter { predicate.evaluate(with: $0) }) else {
            return result
        }

        let nodes = self.nodeCreator.createNodes(fetchedObjects: filtered, byPredicate: predicate)
        result.append(contentsOf: nodes)

        return result
    }
}

extension WOTDataTanksFetchController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(String(describing: indexPath))
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }

}
