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

    private let collection = UOWStateCollection<T>()
    private var dependencyCollection: DependencyCollectionType = [:]

    private let progressEvents = PassthroughSubject<UOWStatus<T>, Never>()

    func addAndNotify(_ subject: T, parent: T?) {
        //
        collection.link(subject, parent: parent) { subject, parent in

            if let parent = parent {
                let count = self.collection.subordinatesCount(subject: parent)
                let status = UOWStatus(subject: parent, statement: .link(count))
                self.progressEvents.send(status)
            }
            if subject != parent {
                let count = self.collection.subordinatesCount(subject: subject)
                let status = UOWStatus(subject: subject, statement: .link(count))
                self.progressEvents.send(status)
            }
        }
    }

    func removeAndNotify(_ subject: T) {
        collection.unlink(subject) { (subject, statement) in
            let status = UOWStatus(subject: subject, statement: statement)
            self.progressEvents.send(status)
        }
    }

    /// used for unit-tests only
    func getCollection() -> DependencyCollectionType {
        return collection.dependencyCollection
    }
}

// MARK: - UOWStateCollection

class UOWStateCollection<T: Hashable> {
    typealias LinkCompletionType = (_ subject: T, _ parent: T?) -> Void
    var dependencyCollection: [T: [T]] = [:]
    private let lock = NSRecursiveLock()

    func link(_ subject: T, parent: T?, competion: LinkCompletionType?) {
        //
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

    func unlink(_ subject: T, completion: ((T, UOWStatement) -> Void)?) {
        lock.lock()

        if subordinatesCount(subject: subject) > 0 {
            //
            unlink(subject, fromParent: subject)
            if subordinatesCount(subject: subject) > 0 {
                let subordinates = subordinatesCount(subject: subject)
                completion?(subject, .unlinkFromParent(subordinates))
            } else {
                unlink(subject)
                removeEmptyNodes(skipCompletionFor: nil) { emptyNode in
                    let subordinates = self.subordinatesCount(subject: emptyNode)
                    completion?(emptyNode, .removeEmptyNode(subordinates))
                }
            }

        } else {
            //
            unlink(subject)

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

    func subordinatesCount(subject: T) -> Int {
        return subordinates(subject: subject).count
    }

    // MARK: - private

    private func unlink(_ subject: T) {
        dependenciesContaining(subject: subject).forEach { parent in
            unlink(subject, fromParent: parent)
        }
    }

    private func unlink(_ subject: T, fromParent: T) {
        dependencyCollection[fromParent]?.removeAll(where: { $0 == subject })
    }

    private func remove(_ subject: T) {
        dependencyCollection.removeValue(forKey: subject)
    }

    private func removeEmptyNodes(skipCompletionFor: T?, completion: ((T) -> Void)?) {
        let keysToRemove = dependencyCollection.keys.compactMap { key in
            return (childrenCount(key) > 0) ? nil : key
        }
        if keysToRemove.isEmpty {
            return
        }
        keysToRemove.forEach {
            unlink($0)
            remove($0)
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

    private func dependenciesContaining(subject: T) -> [T] {
        return dependencyCollection.keys.filter { key in
            key != subject && (dependencyCollection[key]?.contains(subject) ?? false)
        }
    }

    private func childrenCount(_ subject: T) -> Int {
        return dependencyCollection[subject]?.count ?? 0
    }

    private func subordinates(subject: T) -> [T] {
        var result: [T] = []
        dependencyCollection[subject]?.forEach { subordinate in
            result.append(subordinate)
            if subordinate != subject {
                // recursion
                let subordinates = subordinates(subject: subordinate)
                result.append(contentsOf: subordinates)
            }
        }
        return result
    }
}
