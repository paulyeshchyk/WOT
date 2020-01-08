//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import CoreData
import WOTData

class WOTDataTanksFetchController: NSObject {

    private lazy var dataProvider: WOTCoredataProviderProtocol =  {
        return WOTCoreDataProvider.sharedInstance
    } ()

    lazy fileprivate var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let context = self.dataProvider.mainManagedObjectContext
        let request = self.nodeFetchRequestCreator.fetchRequest
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        return result
    }()

    var listener: WOTDataFetchControllerListenerProtocol?
    var nodeFetchRequestCreator: WOTDataFetchControllerDelegateProtocol

    @objc
    var nodeCreator: WOTNodeCreatorProtocol?

    @objc
    init(nodeFetchRequestCreator nfrc: WOTDataFetchControllerDelegateProtocol) {
        nodeFetchRequestCreator = nfrc
    }

    deinit {
        self.fetchResultController.delegate = nil
    }
}

extension WOTDataTanksFetchController: WOTDataFetchControllerProtocol {
    func performFetch() throws {
        self.fetchResultController.managedObjectContext.perform({
            do {
                try self.fetchResultController.performFetch()
                self.listener?.fetchPerformed(by: self)
            } catch let error {
                self.listener?.fetchFailed(by: self, withError: error)
            }
        })
    }

    func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    func fetchedObjects() -> [AnyObject]? {
        return self.fetchResultController.fetchedObjects
    }

    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol] {

        var result = [WOTNodeProtocol]()

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        guard let filtered = (self.fetchedObjects()?.filter { predicate.evaluate(with: $0) }) else {
            return result
        }

        if let nodes = self.nodeCreator?.createNodes(fetchedObjects: filtered, byPredicate: predicate) {
            result.append(contentsOf: nodes)
        }

        return result
    }
}

extension WOTDataTanksFetchController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil
    }
}
