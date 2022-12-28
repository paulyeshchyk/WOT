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

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let modulesTree = fetchResult.managedObject() as? ModulesTree else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(ModulesTree.self))
            return
        }
        guard let vehicles = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? Vehicles else {
            let received = masterFetchResult != nil ? Swift.type(of: masterFetchResult!) : nil
            let error = ModuleLinkerUnexpectedClassError(extected: Vehicles.self, received: received)
            completion(fetchResult, error)
            return
        }
        modulesTree.default_profile = vehicles.default_profile
        vehicles.addToModules_tree(modulesTree)

        // MARK: stash
        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
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
