//
//  UOWStateCollectionContainer.swift
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

class UOWStateCollectionContainer<T: UOWStateSubject> {

    typealias DependencyCollectionType = [T: [T]]

    var deletionEventsPublisher: AnyPublisher<UOWState<T>, Never> {
        deletionEvents.eraseToAnyPublisher()
    }

    var additionEventsPublisher: AnyPublisher<(T, T?), Never> {
        additionEvents.eraseToAnyPublisher()
    }

    private var dependencyCollection: DependencyCollectionType = [:]
    private let lock = NSRecursiveLock()
    private let additionEvents = PassthroughSubject<(T, T?), Never>()
    private let deletionEvents = PassthroughSubject<UOWState<T>, Never>()

    func addAndNotify(_ subject: T, parent: T?) {
        add(subject, parent: parent) { subject, parent in
            self.additionEvents.send((subject, parent))
        }
    }

    func removeAndNotify(_ subject: T) {
        remove(subject) { subject, completed in
            self.deletionEvents.send(UOWState(subject: subject, completed: completed))
        }
    }

    /// used for unit-tests only
    func getCollection() -> DependencyCollectionType {
        return dependencyCollection
    }

    private func add(_ subject: T, parent: T?, competion: ((T, T?) -> Void)?) {
        lock.lock()

        if !dependencyCollection.keys.contains(subject), parent == nil {
            dependencyCollection[subject] = [subject]
        }
        if let parent = parent {
            dependencyCollection[parent, default: [parent]].append(subject)
        }
        lock.unlock()
        competion?(subject, parent)
    }

    private func remove(_ subject: T, completion: ((T, Bool) -> Void)?) {
        lock.lock()

        if hasChildren(subject) {
            remove(subject, fromParent: subject)
            completion?(subject, false)
        } else {
            remove(subject)
            completion?(subject, true)

            removeEmptyNodes().forEach {
                completion?($0, true)
            }
        }

        lock.unlock()
    }

    private func remove(_ subject: T, fromParent: T) {
        dependencyCollection[fromParent]?.removeAll(where: { $0 == subject })
    }

    private func hasChildren(_ subject: T) -> Bool {
        return childrenCount(subject) > 0
    }

    private func childrenCount(_ subject: T) -> Int {
        return dependencyCollection[subject]?.count ?? 0
    }

    private func remove(_ subject: T) {
        nodeListContaining(subject: subject).forEach { parent in
            remove(subject, fromParent: parent)
        }
    }

    private func removeEmptyNodes() -> [T] {
        let keysToRemove = dependencyCollection.keys.compactMap { key in
            return hasChildren(key) ? nil : key
        }
        if keysToRemove.isEmpty {
            return []
        }
        keysToRemove.forEach {
            remove($0)
            dependencyCollection.removeValue(forKey: $0)
        }

        let nextIteration = removeEmptyNodes()
        return keysToRemove + nextIteration
    }

    private func nodeListContaining(subject: T) -> [T] {
        return dependencyCollection.keys.filter { key in
            key != subject && (dependencyCollection[key]?.contains(subject) ?? false)
        }
    }
}
