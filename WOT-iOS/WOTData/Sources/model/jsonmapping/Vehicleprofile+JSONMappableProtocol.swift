//
//  Vehicleprofile+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import WOTKit

// MARK: - CaseBuilder
public protocol CaseBuilderProtocol {
    func build(json: JSON, pkCase: PKCase, foreignSelectKey: String, parents: [AnyObject]?) -> PKCase?
}

public class CaseBuilder1: CaseBuilderProtocol {
    public func build(json: JSON, pkCase: PKCase, foreignSelectKey: String, parents: [AnyObject]?) -> PKCase? {
        let itemCase = PKCase(parentObjects: parents)

        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        return itemCase
    }
}

// MARK: - JSONMappableProtocol

extension Vehicleprofile {
    //
    private func linkItems(from array: [Any]?, clazz: NSManagedObject.Type, primaryKeyType: PrimaryKeyType, linkerType: JSONAdapterLinkerProtocol.Type, foreignSelectKey: String, pkCase: PKCase, parents: [AnyObject]?, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let itemsList = array else { return }

        let itemCase = PKCase(parentObjects: parents)

        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }

        let linker = linkerType.init(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        mappingCoordinator?.fetchLocal(array: itemsList, context: context, forClass: clazz, pkCase: itemCase, linker: linker, callback: { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    private func linkItem(from json: JSON?, clazz: PrimaryKeypathProtocol.Type, primaryKeyType: PrimaryKeyType, linkerType: JSONAdapterLinkerProtocol.Type, foreignSelectKey: String, pkCase: PKCase, parents: [AnyObject]?, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let itemsJSON = json else { return }

        let itemCase = PKCase(parentObjects: parents)
        let itemID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: primaryKeyType) {
            itemID = itemsJSON[idKeyPath]
        } else {
            itemID = nil
        }
        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        let linker = linkerType.init(objectID: self.objectID, identifier: itemID, coreDataStore: mappingCoordinator?.coreDataStore)
        mappingCoordinator?.fetchLocal(json: itemsJSON, context: context, forClass: clazz, pkCase: itemCase, linker: linker, callback: { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    private func linkItem2(from json: JSON?, clazz: PrimaryKeypathProtocol.Type, primaryKeyType: PrimaryKeyType, linkerType: JSONAdapterLinkerProtocol.Type, pkCase: PKCase, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let itemJSON = json else { return }

        let itemCase = PKCase()
        let itemID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: primaryKeyType) {
            itemID = itemJSON[idKeyPath]
        } else {
            itemID = nil
        }
        guard let itemID1 = itemID else { return }

        if let primaryID = clazz.primaryKey(for: itemID1, andType: primaryKeyType) {
            itemCase[.primary] = primaryID
        }

        let linker = linkerType.init(objectID: self.objectID, identifier: itemID1, coreDataStore: mappingCoordinator?.coreDataStore)
        mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: clazz, pkCase: itemCase, linker: linker, callback: { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        // MARK: - Decode properties

        try self.decode(json: json)

        // MARK: - Link items

        var parents = pkCase.plainParents
        parents.append(self)

        // MARK: - Armor
        let armorJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON
        let armorListLinkerType = Vehicleprofile.VehicleprofileArmorListLinker.self
        linkItem(from: armorJSON, clazz: VehicleprofileArmorList.self, primaryKeyType: .none, linkerType: armorListLinkerType, foreignSelectKey: #keyPath(VehicleprofileArmorList.vehicleprofile), pkCase: pkCase, parents: parents, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Ammo
        let ammoListArray = json[#keyPath(Vehicleprofile.ammo)] as? [Any]
        let ammoListLinkerType = Vehicleprofile.VehicleprofileAmmoListLinker.self
        let caseBuilder = CaseBuilder1()
        linkItems(from: ammoListArray, clazz: VehicleprofileAmmoList.self, primaryKeyType: .none, linkerType: ammoListLinkerType, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), pkCase: pkCase, parents: parents, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Modules
        let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON
        let moduleLinkerType = Vehicleprofile.VehicleprofileModuleLinker.self
        linkItem(from: moduleJSON, clazz: VehicleprofileModule.self, primaryKeyType: .none, linkerType: moduleLinkerType, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), pkCase: pkCase, parents: parents, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Engine
        let engineJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON
        let engineLinkerType = Vehicleprofile.VehicleprofileEngineLinker.self
        linkItem2(from: engineJSON, clazz: VehicleprofileEngine.self, primaryKeyType: .internal, linkerType: engineLinkerType, pkCase: pkCase, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Gun
        let gunJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON
        let gunLinkerType = Vehicleprofile.VehicleprofileGunLinker.self
        linkItem2(from: gunJSON, clazz: VehicleprofileGun.self, primaryKeyType: .internal, linkerType: gunLinkerType, pkCase: pkCase, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Suspension
        let suspensionJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON
        let suspensionLinkerType = Vehicleprofile.VehicleprofileSuspensionLinker.self
        linkItem2(from: suspensionJSON, clazz: VehicleprofileSuspension.self, primaryKeyType: .internal, linkerType: suspensionLinkerType, pkCase: pkCase, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Turret
        let turretJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON
        let turretLinkerType = Vehicleprofile.VehicleprofileTurretLinker.self
        linkItem2(from: turretJSON, clazz: VehicleprofileTurret.self, primaryKeyType: .internal, linkerType: turretLinkerType, pkCase: pkCase, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Radio
        let radioJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON
        let radioLinkerType = Vehicleprofile.VehicleprofileRadioLinker.self
        linkItem2(from: radioJSON, clazz: VehicleprofileRadio.self, primaryKeyType: .internal, linkerType: radioLinkerType, pkCase: pkCase, context: context, mappingCoordinator: mappingCoordinator)
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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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

        public func onJSONExtraction(json: JSON) -> JSON { return json }

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
