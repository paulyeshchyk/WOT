//
//  NodeFetchController.swift
//  WOT-iOS
//
//  Created on 7/19/18.
//  Copyright © 2018. All rights reserved.
//

import ContextSDK
import CoreData

public typealias FilteredObjectCompletion = (NSPredicate, [AnyObject]?) -> Void

public typealias NodeFetchedResultController = NSFetchedResultsController<NSFetchRequestResult>

@objc
public protocol PivotFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}

@objc
open class NodeFetchController: NSObject {
    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol

    public var listener: NodeFetchControllerListenerProtocol?
    public var nodeFetchRequestCreator: PivotFetchControllerDelegateProtocol
    private var fetchResultController: NodeFetchedResultController?
    private let appContext: Context

    @objc
    public required init(nodeFetchRequestCreator: PivotFetchControllerDelegateProtocol, appContext: Context) {
        self.nodeFetchRequestCreator = nodeFetchRequestCreator
        self.appContext = appContext
    }

    deinit {
        self.fetchResultController?.delegate = nil
    }

    public func initFetchController(block: @escaping (NodeFetchedResultController?, Error?) -> Void) throws {
        guard let managedObjectContext = appContext.dataStore?.workingContext() else {
            throw NodeFetchControllerError.contextIsNotDefined
        }

        appContext.dataStore?.perform(objectContext: managedObjectContext) {[weak self] context in
            guard let request = self?.nodeFetchRequestCreator.fetchRequest else {
                block(nil, NodeFetchControllerError.requestNotFound)
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

    private func newFetchResultController(request: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: ManagedObjectContextProtocol) throws -> NodeFetchedResultController? {
        let result = try appContext.dataStore?.fetchResultController(for: request, andContext: managedObjectContext) as? NodeFetchedResultController
        result?.delegate = self
        return result
    }
}

enum NodeFetchControllerError: Error, CustomStringConvertible {
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

extension NodeFetchController: NSFetchedResultsControllerDelegate {
    public func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {}

    public func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: NSFetchedResultsSectionInfo, atSectionIndex _: Int, for _: NSFetchedResultsChangeType) {}

    public func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controller(_: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName _: String) -> String? { return nil }
}

extension NodeFetchController: NodeFetchControllerProtocol {
    open func performFetch(nodeCreator: NodeCreatorProtocol?) throws {
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

    private func performFetch(with: NodeFetchedResultController?, nodeCreator _: NodeCreatorProtocol?) throws {
        guard let fetchResultController = with else {
            throw NodeFetchControllerError.noFetchResultControllerCreated
        }
        do {
            try fetchResultController.performFetch()
            listener?.fetchPerformed(by: self)
        } catch let error {
            self.listener?.fetchFailed(by: self, withError: error)
        }
        fetchResultController.delegate = nil
    }

    open func setFetchListener(_ listener: NodeFetchControllerListenerProtocol?) {
        self.listener = listener
    }

    open func fetchedObjects() -> [AnyObject]? {
        return fetchResultController?.fetchedObjects
    }

    open func fetchedNodes(byPredicates: [NSPredicate], nodeCreator _: NodeCreatorProtocol?, filteredCompletion: FilteredObjectCompletion) {
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: byPredicates)

        let filtered = (fetchedObjects()?.filter { predicate.evaluate(with: $0) })
        filteredCompletion(predicate, filtered)
    }
}
