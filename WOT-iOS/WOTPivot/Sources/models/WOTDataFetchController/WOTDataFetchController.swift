//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import CoreData
import WOTKit

public typealias FilteredObjectCompletion = (NSPredicate, [AnyObject]?) -> Void

public typealias WOTDataFetchedResultController = NSFetchedResultsController<NSFetchRequestResult>

@objc
public protocol WOTDataFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}

open class WOTDataFetchController: NSObject {
    public var fetchResultController: WOTDataFetchedResultController?

    public func initFetchController(block: @escaping (WOTDataFetchedResultController) -> Void) throws {
        guard let managedObjectContext = self.dataProvider?.workingContext() else {
            throw WOTCoredataStoreError.contextIsNotDefined
        }

        self.dataProvider?.perform(objectContext: managedObjectContext) { context in

            let request = self.nodeFetchRequestCreator.fetchRequest
            guard let result = self.dataProvider?.fetchResultController(for: request, andContext: context) else {
                fatalError("no FetchResultController created")
            }
            result.delegate = self
            block(result)
        }
    }

    public var listener: WOTDataFetchControllerListenerProtocol?
    public var nodeFetchRequestCreator: WOTDataFetchControllerDelegateProtocol
    public var dataProvider: WOTDataLocalStoreProtocol?

    @objc
    public required init(nodeFetchRequestCreator nfrc: WOTDataFetchControllerDelegateProtocol, dataprovider: WOTDataLocalStoreProtocol?) {
        self.nodeFetchRequestCreator = nfrc
        self.dataProvider = dataprovider
    }

    deinit {
        self.fetchResultController?.delegate = nil
    }
}

extension WOTDataFetchController: NSFetchedResultsControllerDelegate {
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {}

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {}

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? { return nil }
}
