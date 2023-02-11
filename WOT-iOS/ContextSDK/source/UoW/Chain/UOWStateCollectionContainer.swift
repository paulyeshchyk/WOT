//
//  UOWStateCollectionContainer.swift
//  ContextSDK
//
//  Created by Paul on 3.02.23.
//

import Combine

// MARK: - UOWStateCollectionContainer

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

class UOWStateCollectionContainer<T: UOWStatusSubject> {

    typealias DependencyCollectionType = [T: [T]]

    var progressEventsPublisher: AnyPublisher<UOWStatus<T>, Never> {
        progressEvents.eraseToAnyPublisher()
    }

    var additionEventsPublisher: AnyPublisher<UOWRelation<T>, Never> {
        additionEvents.eraseToAnyPublisher()
    }

    private let collection = UOWStateCollection<T>()
    private var dependencyCollection: DependencyCollectionType = [:]

    private let additionEvents = PassthroughSubject<UOWRelation<T>, Never>()
    private let progressEvents = PassthroughSubject<UOWStatus<T>, Never>()

    func addAndNotify(_ subject: T, parent: T?) {
        collection.add(subject, parent: parent) { subject, parent in
            let relation = UOWRelation(subject: subject, parent: parent)
            self.additionEvents.send(relation)
        }
    }

    func removeAndNotify(_ subject: T) {
        collection.remove(subject) { (subject, stage) in
            let state = UOWStatus(subject: subject, stage: stage)
            self.progressEvents.send(state)
        }
    }

    /// used for unit-tests only
    func getCollection() -> DependencyCollectionType {
        return collection.dependencyCollection
    }
}

// MARK: - UOWStateCollection

class UOWStateCollection<T: Hashable> {

    var dependencyCollection: [T: [T]] = [:]
    private let lock = NSRecursiveLock()

    func addRelation(_ subject: T, parent: T?) {
        lock.lock()
        if !dependencyCollection.keys.contains(subject), parent == nil {
            dependencyCollection[subject] = [subject]
        }
        if let parent = parent {
            dependencyCollection[parent, default: [parent]].append(subject)
        }
        lock.unlock()
    }

    func add(_ subject: T, parent: T?, competion: ((_ subject: T, _ parent: T?) -> Void)?) {
        //
        addRelation(subject, parent: parent)

        if let parent = parent {
            let subordinates = subordinatesCount(subject: parent)
        }

        competion?(subject, parent)
    }

    private func dependenciesContaining(subject: T) -> [T] {
        return dependencyCollection.keys.filter { key in
            key != subject && (dependencyCollection[key]?.contains(subject) ?? false)
        }
    }

    private func remove(_ subject: T) {
        dependenciesContaining(subject: subject).forEach { parent in
            remove(subject, fromParent: parent)
        }
    }

    func remove(_ subject: T, completion: ((T, UOWStage) -> Void)?) {
        lock.lock()

        if hasChildren(subject) {
            //
            remove(subject, fromParent: subject)

            let subordinates = subordinatesCount(subject: subject)
            completion?(subject, .unlinkFromParent(subordinates))
        } else {
            //
            remove(subject)

            let count = subordinatesCount(subject: subject)
            completion?(subject, .unlink(count))

            let skipCompletionFor: T? = (count == 0) ? subject : nil

            removeEmptyNodes(skipCompletionFor: skipCompletionFor) { emptyNode in
                let subordinates = self.subordinatesCount(subject: emptyNode)
                completion?(emptyNode, .removeEmptyNode(subordinates))
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

    private func removeEmptyNodes(skipCompletionFor: T?, completion: ((T) -> Void)?) {
        let keysToRemove = dependencyCollection.keys.compactMap { key in
            return hasChildren(key) ? nil : key
        }
        if keysToRemove.isEmpty {
            return
        }
        keysToRemove.forEach {
            remove($0)
            dependencyCollection.removeValue(forKey: $0)
            if let skipCompletionFor = skipCompletionFor {
                if skipCompletionFor != $0 {
                    completion?($0)
                }
            } else {
                completion?($0)
            }
        }

        // recursion
        removeEmptyNodes(skipCompletionFor: skipCompletionFor, completion: completion)
    }

    private func subordinatesCount(subject: T) -> Int {
        lock.lock()
        let result = subordinates(subject: subject).count
        lock.unlock()
        return result
    }

    private func subordinates(subject: T) -> [T] {
        var result: [T] = []
        dependencyCollection[subject]?.forEach { subordinate in
            result.append(subordinate)
            if subordinate != subject {
                let subordinates = subordinates(subject: subordinate)
                result.append(contentsOf: subordinates)
            }
        }
        return result
    }
}
