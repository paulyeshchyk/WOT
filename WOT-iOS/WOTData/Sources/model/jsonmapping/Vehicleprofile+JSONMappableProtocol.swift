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

public struct CaseIdenPair {
    let ident: Any?
    let pkCase: PKCase
}

public protocol CaseBuilderProtocol {
    func build() -> CaseIdenPair?
}

public class CaseBuilderParentList: CaseBuilderProtocol {
    private var pkCase: PKCase
    private var foreignSelectKey: String
    private var parentObjectIDList: [NSManagedObjectID]?

    public init(pkCase: PKCase, foreignSelectKey: String, parents: [NSManagedObjectID]?) {
        self.pkCase = pkCase
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parents
    }

    public func build() -> CaseIdenPair? {
        let itemCase = PKCase(parentObjectIDList: parentObjectIDList)

        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        return CaseIdenPair(ident: nil, pkCase: itemCase)
    }
}

public class CaseBuilderParentListAndObjectIdent: CaseBuilderProtocol {
    private var json: JSON?
    private var pkCase: PKCase
    private var foreignSelectKey: String
    private var parentObjectIDList: [NSManagedObjectID]?
    private var primaryKeyType: PrimaryKeyType
    private var clazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, pkCase: PKCase, foreignSelectKey: String, parentObjectIDList: [NSManagedObjectID]?, primaryKeyType: PrimaryKeyType, clazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.pkCase = pkCase
        self.foreignSelectKey = foreignSelectKey
        self.parentObjectIDList = parentObjectIDList
        self.primaryKeyType = primaryKeyType
        self.clazz = clazz
    }

    public func build() -> CaseIdenPair? {
        guard let json = self.json else { return nil }

        let itemCase = PKCase(parentObjectIDList: parentObjectIDList)
        let itemID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: primaryKeyType) {
            itemID = json[idKeyPath]
        } else {
            itemID = nil
        }
        if let foreignKey = pkCase[.primary]?.foreignKey(byInsertingComponent: foreignSelectKey) {
            itemCase[.primary] = foreignKey
        }
        return CaseIdenPair(ident: itemID, pkCase: itemCase)
    }
}

public class CaseBuilderObjectIdent: CaseBuilderProtocol {
    private var json: JSON?
    private var primaryKeyType: PrimaryKeyType
    private var clazz: PrimaryKeypathProtocol.Type

    public init(json: JSON?, primaryKeyType: PrimaryKeyType, clazz: PrimaryKeypathProtocol.Type) {
        self.json = json
        self.primaryKeyType = primaryKeyType
        self.clazz = clazz
    }

    public func build() -> CaseIdenPair? {
        guard let json = self.json else { return nil }

        let itemCase = PKCase()
        let itemID: Any?
        if let idKeyPath = clazz.primaryKeyPath(forType: primaryKeyType) {
            itemID = json[idKeyPath]
        } else {
            itemID = nil
        }
        guard let itemID1 = itemID else { return nil }

        if let primaryID = clazz.primaryKey(for: itemID1, andType: primaryKeyType) {
            itemCase[.primary] = primaryID
        }

        return CaseIdenPair(ident: itemID, pkCase: itemCase)
    }
}

// MARK: - JSONMappableProtocol

extension Vehicleprofile {
    //
    private func linkItems(from array: [Any]?, clazz: PrimaryKeypathProtocol.Type, linkerType: JSONAdapterLinkerProtocol.Type, caseBuilder: CaseBuilderProtocol, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let itemsList = array else { return }

        guard let casePair = caseBuilder.build() else {
            return
        }

        let linker = linkerType.init(objectID: objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        mappingCoordinator?.fetchLocal(array: itemsList, context: context, forClass: clazz, pkCase: casePair.pkCase, linker: linker, callback: { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    private func linkItem(from json: JSON?, clazz: PrimaryKeypathProtocol.Type, linkerType: JSONAdapterLinkerProtocol.Type, caseBuilder: CaseBuilderProtocol, context: NSManagedObjectContext, mappingCoordinator: WOTMappingCoordinatorProtocol?) {
        guard let itemJSON = json else { return }

        guard let caseIdentPair = caseBuilder.build() else {
            return
        }

        let linker = linkerType.init(objectID: objectID, identifier: caseIdentPair.ident, coreDataStore: mappingCoordinator?.coreDataStore)
        mappingCoordinator?.fetchLocal(json: itemJSON, context: context, forClass: clazz, pkCase: caseIdentPair.pkCase, linker: linker, callback: { _, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
            }
        })
    }

    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        // MARK: - Decode properties

        try decode(json: json)

        // MARK: - Link items

        var parentObjectIDList = pkCase.parentObjectIDList
        parentObjectIDList.append(self.objectID)

        // MARK: - Ammo

        let ammoListArray = json[#keyPath(Vehicleprofile.ammo)] as? [Any]
        let ammoListLinkerType = Vehicleprofile.VehicleprofileAmmoListLinker.self
        let ammoCaseBuilder = CaseBuilderParentList(pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileAmmoList.vehicleprofile), parents: parentObjectIDList)
        linkItems(from: ammoListArray, clazz: VehicleprofileAmmoList.self, linkerType: ammoListLinkerType, caseBuilder: ammoCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Armor

        let armorJSON = json[#keyPath(Vehicleprofile.armor)] as? JSON
        let armorListLinkerType = Vehicleprofile.VehicleprofileArmorListLinker.self
        let armorCaseBuilder = CaseBuilderParentListAndObjectIdent(json: armorJSON, pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList, primaryKeyType: .none, clazz: VehicleprofileModule.self)
        linkItem(from: armorJSON, clazz: VehicleprofileArmorList.self, linkerType: armorListLinkerType, caseBuilder: armorCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Modules

        let moduleJSON = json[#keyPath(Vehicleprofile.modules)] as? JSON
        let moduleLinkerType = Vehicleprofile.VehicleprofileModuleLinker.self
        let modulesCaseBuilder = CaseBuilderParentListAndObjectIdent(json: moduleJSON, pkCase: pkCase, foreignSelectKey: #keyPath(VehicleprofileModule.vehicleprofile), parentObjectIDList: parentObjectIDList, primaryKeyType: .none, clazz: VehicleprofileModule.self)
        linkItem(from: moduleJSON, clazz: VehicleprofileModule.self, linkerType: moduleLinkerType, caseBuilder: modulesCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Engine

        let engineJSON = json[#keyPath(Vehicleprofile.engine)] as? JSON
        let engineLinkerType = Vehicleprofile.VehicleprofileEngineLinker.self
        let engineCaseBuilder = CaseBuilderObjectIdent(json: engineJSON, primaryKeyType: .internal, clazz: VehicleprofileEngine.self)
        linkItem(from: engineJSON, clazz: VehicleprofileEngine.self, linkerType: engineLinkerType, caseBuilder: engineCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Gun

        let gunJSON = json[#keyPath(Vehicleprofile.gun)] as? JSON
        let gunLinkerType = Vehicleprofile.VehicleprofileGunLinker.self
        let gunCaseBuilder = CaseBuilderObjectIdent(json: gunJSON, primaryKeyType: .internal, clazz: VehicleprofileGun.self)
        linkItem(from: gunJSON, clazz: VehicleprofileGun.self, linkerType: gunLinkerType, caseBuilder: gunCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Suspension

        let suspensionJSON = json[#keyPath(Vehicleprofile.suspension)] as? JSON
        let suspensionLinkerType = Vehicleprofile.VehicleprofileSuspensionLinker.self
        let suspensionCaseBuilder = CaseBuilderObjectIdent(json: suspensionJSON, primaryKeyType: .internal, clazz: VehicleprofileSuspension.self)
        linkItem(from: suspensionJSON, clazz: VehicleprofileSuspension.self, linkerType: suspensionLinkerType, caseBuilder: suspensionCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Turret

        let turretJSON = json[#keyPath(Vehicleprofile.turret)] as? JSON
        let turretLinkerType = Vehicleprofile.VehicleprofileTurretLinker.self
        let turretCaseBuilder = CaseBuilderObjectIdent(json: turretJSON, primaryKeyType: .internal, clazz: VehicleprofileTurret.self)
        linkItem(from: turretJSON, clazz: VehicleprofileTurret.self, linkerType: turretLinkerType, caseBuilder: turretCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)

        // MARK: - Radio

        let radioJSON = json[#keyPath(Vehicleprofile.radio)] as? JSON
        let radioLinkerType = Vehicleprofile.VehicleprofileRadioLinker.self
        let radioCaseBuilder = CaseBuilderObjectIdent(json: radioJSON, primaryKeyType: .internal, clazz: VehicleprofileRadio.self)
        linkItem(from: radioJSON, clazz: VehicleprofileRadio.self, linkerType: radioLinkerType, caseBuilder: radioCaseBuilder, context: context, mappingCoordinator: mappingCoordinator)
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
