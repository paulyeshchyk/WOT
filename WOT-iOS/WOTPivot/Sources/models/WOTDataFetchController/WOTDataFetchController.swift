//
//  WOTDataFetchController.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import CoreData
import WOTKit
import ContextSDK

public typealias FilteredObjectCompletion = (NSPredicate, [AnyObject]?) -> Void

public typealias WOTDataFetchedResultController = NSFetchedResultsController<NSFetchRequestResult>

@objc
public protocol WOTDataFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}

open class WOTDataFetchController: NSObject {
    
    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol
    
    public var fetchResultController: WOTDataFetchedResultController?
    
    enum DataFetchControllerError: Error, CustomStringConvertible {
        case contextIsNotDefined
        case requestNotFound
        case noFetchResultControllerCreated
        var description: String {
            switch self {
            case .contextIsNotDefined: return "Context not defined"
            case .requestNotFound: return "Request not found"
            case .noFetchResultControllerCreated: return "no FetchResultController created"
            }
        }
    }

    public func initFetchController(block: @escaping (WOTDataFetchedResultController?, Error?) -> Void) throws {
        guard let managedObjectContext = dataStore?.workingContext() else {
            throw DataFetchControllerError.contextIsNotDefined
        }

        dataStore?.perform(objectContext: managedObjectContext) {[weak self] context in
            guard let request = self?.nodeFetchRequestCreator.fetchRequest else {
                block(nil, DataFetchControllerError.requestNotFound)
                return
            }
            do {
                let result = try self?.newFetchResultController(request: request, managedObjectContext: context)
                block(result, nil)
            } catch {
                block(nil, error)
            }
        }
    }
    
    private func newFetchResultController(request: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: ManagedObjectContextProtocol) throws -> NSFetchedResultsController<NSFetchRequestResult>? {
        let result = try context.dataStore?.fetchResultController(for: request, andContext: managedObjectContext) as? NSFetchedResultsController<NSFetchRequestResult>
        result?.delegate = self
        return result
    }

    public var listener: WOTDataFetchControllerListenerProtocol?
    public var nodeFetchRequestCreator: WOTDataFetchControllerDelegateProtocol
    public var dataStore: DataStoreProtocol?
    let context: Context

    @objc
    public required init(nodeFetchRequestCreator nfrc: WOTDataFetchControllerDelegateProtocol, context: Context) {
        self.nodeFetchRequestCreator = nfrc
        self.context = context
        self.dataStore = context.dataStore
        
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
