//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - JSONMappableProtocol

extension Vehicleprofile {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase parentCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        var parents = parentCase.plainParents
        parents.append(self)

        if let itemsList = json[#keyPath(Vehicleprofile.ammo)] as? [Any] {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = parentCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoList.vehicleprofile))
            let linker = Vehicleprofile.VehicleprofileAmmoListLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(array: itemsList, context: context, forClass: VehicleprofileAmmoList.self, pkCase: itemCase, linker: linker, callback: { _, error in
                if let error = error {
                    print(error.debugDescription)
                }
            })
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = parentCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileArmorList.vehicleprofile))
            let linker = Vehicleprofile.VehicleprofileArmorListLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileArmorList.self, pkCase: itemCase, linker: linker, callback: { _, error in
                if let error = error {
                    print(error.debugDescription)
                }
            })
        }

        if let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON {
            let itemCase = PKCase(parentObjects: parents)
            itemCase[.primary] = parentCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileModule.vehicleprofile))
            let linker = Vehicleprofile.VehicleprofileModuleLinker(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
            mappingCoordinator?.fetchLocal(json: moduleJSON, context: context, forClass: VehicleprofileModule.self, pkCase: itemCase, linker: linker, callback: { _, error in
                if let error = error {
                    print(error.debugDescription)
                }
            })
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON {
            if let itemID = itemJSON[VehicleprofileGun.primaryKeyPath(forType: .internal)] {
                let itemCase = PKCase()
                itemCase[.primary] = VehicleprofileGun.primaryKey(for: itemID, andType: .internal)
                let linker = Vehicleprofile.VehicleprofileGunLinker(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileGun.self, pkCase: itemCase, linker: linker, callback: { _, error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                })
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON {
            if let itemID = itemJSON[VehicleprofileSuspension.primaryKeyPath(forType: .internal)] {
                let itemCase = PKCase()
                itemCase[.primary] = VehicleprofileSuspension.primaryKey(for: itemID, andType: .internal)
                let linker = Vehicleprofile.VehicleprofileSuspensionLinker(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileSuspension.self, pkCase: itemCase, linker: linker, callback: { _, error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                })
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON {
            if let itemID = itemJSON[VehicleprofileRadio.primaryKeyPath(forType: .internal)] {
                let itemCase = PKCase()
                itemCase[.primary] = VehicleprofileRadio.primaryKey(for: itemID, andType: .internal)
                let linker = Vehicleprofile.VehicleprofileRadioLinker(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileRadio.self, pkCase: itemCase, linker: linker, callback: { _, error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                })
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON {
            if let itemID = itemJSON[VehicleprofileEngine.primaryKeyPath(forType: .internal)] {
                let itemCase = PKCase()
                itemCase[.primary] = VehicleprofileEngine.primaryKey(for: itemID, andType: .internal)
                let linker = Vehicleprofile.VehicleprofileEngineLinker(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileEngine.self, pkCase: itemCase, linker: linker, callback: { _, error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                })
            }
        }

        if let itemJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON {
            if let itemID = itemJSON[VehicleprofileTurret.primaryKeyPath(forType: .internal)] {
                let itemCase = PKCase()
                itemCase[.primary] = VehicleprofileTurret.primaryKey(for: itemID, andType: .internal)
                let linker = Vehicleprofile.VehicleprofileTurretLinker(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
                mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: VehicleprofileTurret.self, pkCase: itemCase, linker: linker, callback: { _, error in
                    if let error = error {
                        print(error.debugDescription)
                    }
                })
            }
        }
    }
}

extension Vehicleprofile {
    public class VehicleprofileRadioLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let radio = fetchResult.managedObject() as? VehicleprofileRadio {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.radio = radio

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileTurretLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let turret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.turret = turret

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileSuspensionLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let suspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.suspension = suspension

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileGunLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let gun = fetchResult.managedObject() as? VehicleprofileGun {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.gun = gun

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileModuleLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let modules = fetchResult.managedObject() as? VehicleprofileModule {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.modules = modules
                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileEngineLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let engine = fetchResult.managedObject() as? VehicleprofileEngine {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.engine = engine

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileArmorListLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let armorList = fetchResult.managedObject() as? VehicleprofileArmorList {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.armor = armorList

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }

    public class VehicleprofileAmmoListLinker: JSONAdapterLinkerProtocol {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func process(fetchResult: FetchResult, completion: @escaping FetchResultErrorCompletion) {
            let context = fetchResult.context
            if let ammoList = fetchResult.managedObject() as? VehicleprofileAmmoList {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.ammo = ammoList

                    coreDataStore?.stash(context: context) { error in
                        completion(fetchResult, error)
                    }
                }
            }
        }
    }
}
