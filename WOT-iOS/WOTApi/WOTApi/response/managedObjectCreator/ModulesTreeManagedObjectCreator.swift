//
//  ModulesTreeManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class ModulesTreeManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, dataStore: DataStoreProtocol?, completion: @escaping FetchResultCompletion) {
        let objectContext = fetchResult.managedObjectContext
        let childObject = fetchResult.managedObject()

        guard let modulesTree = childObject as? ModulesTree else {
            let error = ModuleLinkerUnexpectedClassError(extected: ModulesTree.self, received: childObject)
            completion(fetchResult, error)
            return
        }
        guard let vehicles = masterFetchResult?.managedObject(inManagedObjectContext: objectContext) as? Vehicles else {
            let received = masterFetchResult != nil ? Swift.type(of: masterFetchResult!) : nil
            let error = ModuleLinkerUnexpectedClassError(extected: Vehicles.self, received: received)
            completion(fetchResult, error)
            return
        }
        modulesTree.default_profile = vehicles.default_profile
        vehicles.addToModules_tree(modulesTree)
        dataStore?.stash(objectContext: objectContext) { error in
            completion(fetchResult, error)
        }
    }
}

private struct ModuleLinkerUnexpectedClassError: Error, CustomStringConvertible {
    var expected: AnyClass
    var received: AnyObject?
    public init(extected exp: AnyClass, received rec: AnyObject?) {
        self.expected = exp
        self.received = rec
    }

    var description: String {
        return "[\(type(of: self))]: exprected (\(String(describing: expected))), received (\(String(describing: received ?? NSNull.self)))"
    }
}
