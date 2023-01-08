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

// MARK: - FetchRequestContainerProtocol

@objc
public protocol FetchRequestContainerProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> { get }
}

public extension NodeFetchController {
    @objc
    convenience init(objCFetchRequestContainer: FetchRequestContainerProtocol, appContext: Context) {
        self.init(fetchRequestContainer: objCFetchRequestContainer, appContext: appContext)
    }
}

// MARK: - NodeFetchController

open class NodeFetchController: NSObject {

    public var listener: NodeFetchControllerListenerProtocol?
    public var fetchRequestContainer: FetchRequestContainerProtocol

    private var fetchResultController: NodeFetchedResultController?
    private let appContext: NodeFetchControllerProtocol.Context

    // MARK: Lifecycle

    public required init(fetchRequestContainer: FetchRequestContainerProtocol, appContext: NodeFetchControllerProtocol.Context) {
        self.fetchRequestContainer = fetchRequestContainer
        self.appContext = appContext
    }

    deinit {
        self.fetchResultController?.delegate = nil
    }

    // MARK: Public

    public func initFetchController(appContext: NodeFetchControllerProtocol.Context, block: @escaping (NodeFetchedResultController?, Error?) -> Void) throws {
        //
        appContext.dataStore?.perform { [weak self] managedObjectContext in
            guard let fetchRequest = self?.fetchRequestContainer.fetchRequest else {
                block(nil, NodeFetchControllerError.requestNotFound)
                return
            }
            do {
                let result = try appContext.dataStore?.fetchResultController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext) as? NodeFetchedResultController
                block(result, nil)
            } catch {
                block(nil, error)
            }
        }
    }

}

// MARK: - NodeFetchControllerError

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

// MARK: - NodeFetchController + NSFetchedResultsControllerDelegate

extension NodeFetchController: NSFetchedResultsControllerDelegate {
    public func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at _: IndexPath?, for _: NSFetchedResultsChangeType, newIndexPath _: IndexPath?) {}

    public func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: NSFetchedResultsSectionInfo, atSectionIndex _: Int, for _: NSFetchedResultsChangeType) {}

    public func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {}

    public func controller(_: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName _: String) -> String? { return nil }
}

// MARK: - NodeFetchController + NodeFetchControllerProtocol

extension NodeFetchController: NodeFetchControllerProtocol {
    open func performFetch(nodeCreator: NodeCreatorProtocol?, appContext: NodeFetchControllerProtocol.Context) throws {
        if let fetch = fetchResultController {
            try performFetch(with: fetch, nodeCreator: nodeCreator)
        } else {
            try initFetchController(appContext: appContext) { [weak self] fetchResultController, error in

                self?.fetchResultController?.delegate = nil
                self?.fetchResultController = fetchResultController
                self?.fetchResultController?.delegate = self

                if let err = error {
                    self?.appContext.logInspector?.log(.error(err), sender: self)
                } else {
                    do {
                        try self?.performFetch(with: fetchResultController, nodeCreator: nodeCreator)
                    } catch {
                        self?.appContext.logInspector?.log(.error(error), sender: self)
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
