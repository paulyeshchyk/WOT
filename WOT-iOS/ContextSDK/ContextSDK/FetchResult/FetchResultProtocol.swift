//
//  FetchResultProtocol.swift
//  ContextSDK
//
//  Created by Paul on 19.12.22.
//

@objc
public enum FetchStatus: Int {
    case none
    case fetched
    case inserted
    case updated
    case recovered
}

//@objc
//public enum FetchConcurency: Int {
//    case mainQueue
//    case privateQueue
//}
//

@objc
public protocol ObjectContextProtocol: AnyObject {
    var name: String? { get }
    func object(byID: AnyObject) -> AnyObject?
    func performBBlock(_ block: (() -> Void)?)
    func findOrCreateObject(forType: AnyObject, predicate: NSPredicate?) -> AnyObject?
    func hasTheChanges() -> Bool
    func saveContext()
}

@objc
public protocol ManagedObjectProtocol: AnyObject {
    var entityName: String { get }
}

@objc
public protocol FetchResultProtocol: AnyObject {
    var fetchStatus: FetchStatus { get set }
    var predicate: NSPredicate? { get set }
    var objectContext: ObjectContextProtocol? { get set }
    func dublicate() -> FetchResultProtocol
    func managedObject() -> ManagedObjectProtocol?
    func managedObject(inManagedObjectContext context: ObjectContextProtocol?) -> ManagedObjectProtocol?
}
