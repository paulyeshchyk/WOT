//
//  DependencyCollection.swift
//  ContextSDK
//
//  Created by Paul on 3.02.23.
//

import Combine

// MARK: - DependencyCollection

/**

 improvements from OpenAI

 Here are some suggestions to improve the class:

 Naming: Consider renaming the class to something more descriptive and meaningful.

 Error Handling: Add error handling mechanisms to handle cases where inputs are not valid or unexpected.

 Modify the add method: Instead of sending the "completed" event after the add method is called, it might be better to have a separate method for this, like addAndNotify.

 Unused properties: RemovalCompletion property is unused and can be removed.

 Type Safety: Consider making the ChainType type more restrictive by conforming to the Comparable protocol, to ensure that the ordering of elements in the chain is well-defined.

 Mutability: Consider making the class properties more mutable by using value types like struct instead of class, making it thread-safe and easier to use.
 */

class DependencyCollection<T: DependencyCollectionItemType> {

    typealias DependencyCollectionType = [T: [T]]

    var deletionEventsPublisher: AnyPublisher<DependencyCollectionItem<T>, Never> {
        deletionEvents.eraseToAnyPublisher()
    }

    var additionEventsPublisher: AnyPublisher<(T, T?), Never> {
        additionEvents.eraseToAnyPublisher()
    }

    private var collection: DependencyCollectionType = [:]
    private let lock = NSRecursiveLock()
    private let additionEvents = PassthroughSubject<(T, T?), Never>()
    private let deletionEvents = PassthroughSubject<DependencyCollectionItem<T>, Never>()

    func addAndNotify(_ subject: T, parent: T?) {
        lock.lock()

        if !collection.keys.contains(subject), parent == nil {
            collection[subject] = [subject]
        }
        if let parent = parent {
            collection[parent, default: [parent]].append(subject)
        }
        additionEvents.send((subject, parent))
        lock.unlock()
    }

    /// used for unit-tests only
    func getCollection() -> DependencyCollectionType {
        return collection
    }

    func removeAndNotify(_ subject: T) {
        lock.lock()

        if hasChildren(subject) {
            remove(subject, fromParent: subject)
            deletionEvents.send(DependencyCollectionItem(subject: subject, completed: false))
        } else {
            remove(subject)
            deletionEvents.send(DependencyCollectionItem(subject: subject, completed: true))

            removeEmptyNodes().forEach {
                deletionEvents.send(DependencyCollectionItem(subject: $0, completed: true))
            }
        }

        lock.unlock()
    }

    func remove(_ subject: T, fromParent: T) {
        collection[fromParent]?.removeAll(where: { $0 == subject })
    }

    private func removeEmptyNodes() -> [T] {
        let keysToRemove = collection.keys.compactMap { key in
            return hasChildren(key) ? nil : key
        }
        if keysToRemove.isEmpty {
            return []
        }
        keysToRemove.forEach {
            remove($0)
            collection.removeValue(forKey: $0)
        }

        let nextIteration = removeEmptyNodes()
        return keysToRemove + nextIteration
    }

    private func hasChildren(_ subject: T) -> Bool {
        return childrenCount(subject) > 0
    }

    private func childrenCount(_ subject: T) -> Int {
        return collection[subject]?.count ?? 0
    }

    private func remove(_ subject: T) {
        nodeListContaining(subject: subject).forEach { parent in
            remove(subject, fromParent: parent)
        }
    }

    private func nodeListContaining(subject: T) -> [T] {
        return collection.keys.filter { key in
            key != subject && (collection[key]?.contains(subject) ?? false)
        }
    }
}
