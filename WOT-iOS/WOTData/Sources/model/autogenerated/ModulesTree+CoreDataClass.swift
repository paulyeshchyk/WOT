//
//  ModulesTree+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import CoreData
import WOTKit

@objc(ModulesTree)
public class ModulesTree: NSManagedObject {}

// MARK: - Coding Keys

extension ModulesTree {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case module_id
        case name
        case price_credit
        case price_xp
        case is_default
        case type
    }

    public enum RelativeKeys: String, CodingKey, CaseIterable {
        case next_modules
        case next_tanks
        case currentModule
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    @objc
    override public static func relationsKeypaths() -> [String] {
        return RelativeKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(ModulesTree.module_id)
        case .internal: return #keyPath(ModulesTree.module_id)
        }
    }
}

extension ModulesTree {
    override public func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
        var parents = pkCase.plainParents
        parents.append(self)

        // MARK: - CurrentModule
        let currentModuleHelper = ModulesTree.CurrentModuleJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        let currentModulePK = PKCase(parentObjects: parents)
        currentModulePK[.primary] = Module.primaryKey(for: self.module_id as AnyObject, andType: .external)
        mappingCoordinator?.fetchRemote(context: context, byModelClass: Module.self, pkCase: currentModulePK, keypathPrefix: nil, instanceHelper: currentModuleHelper)

        // MARK: - NextModules
        let nextModulesHelper = ModulesTree.NextModulesJSONAdapterHelper(objectID: self.objectID, identifier: nil, coreDataStore: mappingCoordinator?.coreDataStore)
        let nextModules = json[#keyPath(ModulesTree.next_modules)] as? [AnyObject]
        nextModules?.forEach {
            let modulePK = PKCase(parentObjects: parents)
            modulePK[.primary] = pkCase[.primary]
            modulePK[.secondary] = Module.primaryKey(for: $0, andType: .external)
            mappingCoordinator?.fetchRemote(context: context, byModelClass: Module.self, pkCase: modulePK, keypathPrefix: nil, instanceHelper: nextModulesHelper)
        }

        #warning("Next Tanks")
//        // MARK: - NextTanks
//        let nextTanksHelper = ModulesTree.NextTanksJSONAdapterHelper(objectID: self.objectID, identifier: nil, persistentStore: persistentStore)
//        let nextTanks = jSON[#keyPath(ModulesTree.next_tanks)]
//        (nextTanks as? [AnyObject])?.forEach {
//            // parents was not used for next portion of tanks
//            let nextTanksPK = PKCase(parentObjects: nil)
//            nextTanksPK[.primary] = Vehicles.primaryKey(for: $0, andType: .internal)
//            persistentStore?.fetchRemote(context: context, byModelClass: Vehicles.self, pkCase: nextTanksPK, keypathPrefix: nil, instanceHelper: nextTanksHelper)
//        }
    }
}

// MARK: - JSONDecoding

extension ModulesTree: JSONDecodingProtocol {
    public func decodeWith(_ decoder: Decoder) throws {
        let fieldsContainer = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try fieldsContainer.decodeIfPresent(String.self, forKey: .name)
        self.type = try fieldsContainer.decodeIfPresent(String.self, forKey: .type)
        self.module_id = try fieldsContainer.decodeIfPresent(Int.self, forKey: .module_id)?.asDecimal
        self.price_credit = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_credit)?.asDecimal
        self.price_xp = try fieldsContainer.decodeIfPresent(Int.self, forKey: .price_xp)?.asDecimal
        self.is_default = try fieldsContainer.decodeIfPresent(Bool.self, forKey: .is_default)?.asDecimal
    }
}

// MARK: - Customization

extension ModulesTree {
    @objc
    public func localImageURL() -> URL? {
        let type = self.moduleType()
        let name = type.stringValue
        return Bundle.main.url(forResource: name, withExtension: "png")
    }

    @objc
    public func moduleType() -> ObjCVehicleModuleType {
        return .unknown
    }
}

extension ModulesTree {
    public class DefaultProfileJSONAdapterHelper: JSONAdapterInstanceHelper {
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

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let modulesTree = fetchResult.managedObject() as? ModulesTree {
                if let vehicles = context.object(with: objectID) as? Vehicles {
                    modulesTree.default_profile = vehicles.default_profile
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class CurrentModuleJSONAdapterHelper: JSONAdapterInstanceHelper {
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

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let module = fetchResult.managedObject() as? Module {
                if let modulesTree = context.object(with: objectID) as? ModulesTree {
                    modulesTree.currentModule = module
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class NextModulesJSONAdapterHelper: JSONAdapterInstanceHelper {
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

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let nextModule = fetchResult.managedObject() as? Module {
                if let modulesTree = context.object(with: objectID) as? ModulesTree {
                    modulesTree.addToNext_modules(nextModule)
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }

    public class NextTanksJSONAdapterHelper: JSONAdapterInstanceHelper {
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

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let tank = fetchResult.managedObject() as? Vehicles {
                if let modulesTree = context.object(with: objectID) as? ModulesTree {
                    modulesTree.addToNext_tanks(tank)
                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
