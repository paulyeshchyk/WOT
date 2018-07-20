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
        let context = WOTCoreDataProvider.sharedInstance().mainManagedObjectContext
        assert(context != nil, "context should not be nil")

        let request = WOTDataTanksFetchController.fetchRequest()
        let result = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        result.delegate = self
        return result
    }()

    var listener: WOTDataFetchControllerListenerProtocol?

    deinit {
        self.fetchResultController?.delegate = nil
    }

    private static func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Tanks")
        result.sortDescriptors = self.sortDescriptors()
        return result
    }

    private static func sortDescriptors() -> [NSSortDescriptor] {
        var result = WOTTankListSettingsDatasource.sharedInstance().sortBy
        let descriptor = NSSortDescriptor.init(key: "tank_id", ascending: true) //WOT_KEY_TANK_ID
        result.append(descriptor)
        return result
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

    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTPivotNodeProtocol] {

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        var result = [WOTPivotNodeProtocol]()

        let fetchedObjects = self.fetchResultController?.fetchedObjects
        let filtered = fetchedObjects?.filter { predicate.evaluate(with: $0) }

        filtered?.forEach { (fetchedObject) in
            let node = WOTNodeFactory.pivotDataNode(for: predicate, andTanksObject: fetchedObject)
            result.append(node)
        }
        return result
    }
}

extension WOTDataTanksFetchController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        listener?.fetchPerformed(by: self)
    }

}
