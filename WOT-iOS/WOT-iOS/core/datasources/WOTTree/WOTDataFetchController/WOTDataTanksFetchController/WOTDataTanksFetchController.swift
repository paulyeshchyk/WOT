//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/19/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation
import CoreData

@objc
class WOTDataTanksFetchController: NSObject {

    lazy private var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>? = {
        guard let context = WOTCoreDataProvider.sharedInstance().mainManagedObjectContext else {
            return nil
        }
        guard let request = self.nodeCreator?.fetchRequest else {
            return nil
        }
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        return result
    }()

    var listener: WOTDataFetchControllerListenerProtocol?
    weak var nodeCreator: WOTDataFetchControllerDelegateProtocol?

    @objc
    init(delegate nodeCreatorDelegate: WOTDataFetchControllerDelegateProtocol) {
        nodeCreator = nodeCreatorDelegate
    }

    deinit {
        self.fetchResultController?.delegate = nil
    }
}

extension WOTDataTanksFetchController: WOTDataFetchControllerProtocol {

    func performFetch() throws {

        try self.fetchResultController?.performFetch()
        DispatchQueue.main.async {
            self.listener?.fetchPerformed(by: self)
        }
    }

    func setListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    func fetchedObjects() -> [AnyObject]? {
        return self.fetchResultController?.fetchedObjects
    }

    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol] {

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        var result = [WOTNodeProtocol]()

        let filtered = self.fetchedObjects()?.filter { predicate.evaluate(with: $0) }

        filtered?.forEach { (fetchedObject) in
            if let fetchObj = fetchedObject as? NSFetchRequestResult {
                if let node = self.nodeCreator?.createNode(fetchedObject: fetchObj, byPredicate: predicate) {
                    result.append(node)
                }
            }
        }
        return result
    }
}

extension WOTDataTanksFetchController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listener?.fetchPerformed(by: self)
    }

}
