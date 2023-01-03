//
//  ManagedObjectCreator.swift
//  ContextSDK
//
//  Created by Paul on 26.12.22.
//

open class ManagedObjectLinker: ManagedObjectLinkerProtocol, ManagedObjectExtractable {
    // MARK: - Open

    public let uuid: UUID = UUID()
    public var MD5: String { uuid.MD5 }

    public let modelClass: PrimaryKeypathProtocol.Type

    open var linkerPrimaryKeyType: PrimaryKeyType {
        fatalError("has not been implemented")
    }

    // MARK: - Public

    public var masterFetchResult: FetchResultProtocol?
    public var anchor: ManagedObjectLinkerAnchorProtocol

    public required init(modelClass: PrimaryKeypathProtocol.Type, masterFetchResult: FetchResultProtocol?, anchor: ManagedObjectLinkerAnchorProtocol) {
        self.masterFetchResult = masterFetchResult
        self.modelClass = modelClass
        self.anchor = anchor
    }

    open func extractJSON(from _: JSON) -> JSON? { return nil }

    open func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectLinkerContext, completion: @escaping FetchResultCompletion) {
        guard let link = fetchResult.managedObject() as? ManagedObjectLinkable else {
            completion(fetchResult, ManagedObjectLinkerError.unexpectedString(String(describing: ManagedObjectLinkHostable.self)))
            return
        }
        guard let host = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? ManagedObjectLinkHostable else {
            completion(fetchResult, ManagedObjectLinkerError.unexpectedString(String(describing: ManagedObjectLinkable.self)))
            return
        }
        host.doLinking(link, anchor: anchor)

        // MARK: stash

        appContext.dataStore?.stash(managedObjectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }

    public enum ManagedObjectLinkerError: Error, CustomStringConvertible {
        case unexpectedString(String)
        case unexpectedClass(AnyClass)
        case noManagedObjectFound
        public var description: String {
            switch self {
            case .unexpectedString(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(clazz)]"
            case .unexpectedClass(let clazz): return "[\(type(of: self))]: Class is not supported; expected class is:[\(String(describing: clazz))]"
            case .noManagedObjectFound: return "[\(type(of: self))] No managed object found"
            }
        }
    }
}
