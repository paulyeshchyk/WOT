//
//  VehicleprofileAmmoListAmmoManagedObjectCreator.swift
//  WOTApi
//
//  Created by Paul on 28.12.22.
//

public class VehicleprofileAmmoListAmmoManagedObjectCreator: ManagedObjectCreator {
    override public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
    override public func onJSONExtraction(json: JSON) -> JSON? {
        return json
    }

    override public func process(fetchResult: FetchResultProtocol, appContext: ManagedObjectCreatorContext, completion: @escaping FetchResultCompletion) {
        guard let ammo = fetchResult.managedObject() as? VehicleprofileAmmo else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmo.self))
            return
        }
        guard let ammoList = masterFetchResult?.managedObject(inManagedObjectContext: fetchResult.managedObjectContext) as? VehicleprofileAmmoList else {
            completion(fetchResult, BaseJSONAdapterLinkerError.unexpectedClass(VehicleprofileAmmoList.self))
            return
        }
        ammoList.addToVehicleprofileAmmo(ammo)

        // MARK: stash
        appContext.dataStore?.stash(objectContext: fetchResult.managedObjectContext) { error in
            completion(fetchResult, error)
        }
    }
}

public class VehicleprofileAmmoListAmmoRequestPredicateComposer: RequestPredicateComposerProtocol {
    private var requestPredicate: ContextPredicate
    private var ammoType: AnyObject?
    private var linkedClazz: PrimaryKeypathProtocol.Type
    private var foreignSelectKey: String

    public init(requestPredicate: ContextPredicate, ammoType: AnyObject?, linkedClazz: PrimaryKeypathProtocol.Type, foreignSelectKey: String) {
        self.requestPredicate = requestPredicate
        self.linkedClazz = linkedClazz
        self.foreignSelectKey = foreignSelectKey
        self.ammoType = ammoType
    }

    public func build() -> RequestPredicateCompositionProtocol? {
        let lookupPredicate = ContextPredicate()
        lookupPredicate[.primary] = requestPredicate[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey)
        lookupPredicate[.secondary] = linkedClazz.primaryKey(forType: .internal, andObject: ammoType)

        return RequestPredicateComposition(objectIdentifier: nil, requestPredicate: lookupPredicate)
    }
}
