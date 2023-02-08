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

    var additionEventsPublisher: AnyPublisher<UOWRelation<T>, Never> {
        additionEvents.eraseToAnyPublisher()
    }

    private var dependencyCollection: DependencyCollectionType = [:]
    private let lock = NSRecursiveLock()
    private let additionEvents = PassthroughSubject<UOWRelation<T>, Never>()
    private let deletionEvents = PassthroughSubject<UOWState<T>, Never>()

    func addAndNotify(_ subject: T, parent: T?) {
        let relation = UOWRelation(subject: subject, parent: parent)
        add(relation) { relation in
            self.additionEvents.send(relation)
        }
    }

    func removeAndNotify(_ subject: T) {
        remove(subject) { state in
            self.deletionEvents.send(state)
        }
    }

    /// used for unit-tests only
    func getCollection() -> DependencyCollectionType {
        return dependencyCollection
    }

    private func add(_ uowRelation: UOWRelation<T>, competion: ((UOWRelation<T>) -> Void)?) {
        lock.lock()

        if !dependencyCollection.keys.contains(uowRelation.subject), uowRelation.parent == nil {
            dependencyCollection[uowRelation.subject] = [uowRelation.subject]
        }
        if let parent = uowRelation.parent {
            dependencyCollection[parent, default: [parent]].append(uowRelation.subject)
        }
        lock.unlock()
        competion?(uowRelation)
    }

    private func remove(_ subject: T, completion: ((UOWState<T>) -> Void)?) {
        lock.lock()

        if hasChildren(subject) {
            remove(subject, fromParent: subject)
            let state = UOWState(subject: subject, completed: false)
            completion?(state)
        } else {
            remove(subject)

            let state = UOWState(subject: subject, completed: true)
            completion?(state)

            removeEmptyNodes().forEach {
                let state = UOWState(subject: $0, completed: true)
                completion?(state)
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
        dependenciesContaining(subject: subject).forEach { parent in
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

    private func dependenciesContaining(subject: T) -> [T] {
        return dependencyCollection.keys.filter { key in
            key != subject && (dependencyCollection[key]?.contains(subject) ?? false)
        }
    }
}
