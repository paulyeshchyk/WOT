//
//  ModulesTreeJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - ModulesTreeJSONDecoder

class ModulesTreeJSONDecoder: JSONDecoderProtocol {

    var managedObject: (NSManagedObject & DecodableProtocol & ManagedObjectProtocol)?

    func decode(using map: JSONMapProtocol, appContext: JSONDecoderProtocol.Context?, forDepthLevel _: DecodingDepthLevel?) throws {
        guard let managedObject = managedObject else {
            return
        }
        //
        let moduleTreeJSON = try map.data(ofType: JSON.self)
        try managedObject.decode(decoderContainer: moduleTreeJSON)
        let jsonRef = try JSONRef(element: moduleTreeJSON, modelClass: ModulesTree.self)
        //

        // MARK: - NextTanks

        let nextTanksKeypath = #keyPath(ModulesTree.next_tanks)
        if let nextTanks = moduleTreeJSON?[nextTanksKeypath] as? [AnyObject] {
            let socket = JointSocket(managedRef: managedObject.managedRef, identifier: nil, keypath: nextTanksKeypath)
            let linker = ManagedObjectLinker(modelClass: Vehicles.self, socket: socket)
            let extractor = NextVehicleExtractor()
            for nextTank in nextTanks {
                // parents was not used for next portion of tanks
                let pin = JointPin(modelClass: Vehicles.self, identifier: nextTank, contextPredicate: nil)
                let composer = LinkedLocalAsPrimaryRuleBuilder(pin: pin)
                do {
                    let modelClass = Vehicles.self
                    let composition = try composer.buildRequestPredicateComposition()

                    try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: linker, managedObjectExtractor: extractor, listener: nil)
                } catch {
                    appContext?.logInspector?.log(.error(error), sender: self)
                }
            }
        }

        // MARK: - NextModules

        let nextModulesKeypath = #keyPath(ModulesTree.next_modules)
        if let nextModules = moduleTreeJSON?[nextModulesKeypath] as? [AnyObject] {
            let socket = JointSocket(managedRef: managedObject.managedRef, identifier: nil, keypath: nextModulesKeypath)
            let nextModuleManagedObjectCreator = ManagedObjectLinker(modelClass: ModulesTree.self, socket: socket)
            let extractor = NextModuleExtractor()
            let modelClass = Module.self
            for nextModuleID in nextModules {
                let pin = JointPin(modelClass: modelClass, identifier: nextModuleID, contextPredicate: map.contextPredicate)
                let composer = MasterAsPrimaryLinkedAsSecondaryRuleBuilder(pin: pin)
                do {
                    let composition = try composer.buildRequestPredicateComposition()
                    try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: nextModuleManagedObjectCreator, managedObjectExtractor: extractor, listener: nil)
                } catch {
                    appContext?.logInspector?.log(.error(error), sender: self)
                }
            }
        }

        // MARK: - CurrentModule

        let currentModuleKeypath = #keyPath(ModulesTree.currentModule)
        if let identifier = moduleTreeJSON?[#keyPath(ModulesTree.module_id)] {
            let modelClass = Module.self
            let socket = JointSocket(managedRef: managedObject.managedRef, identifier: nil, keypath: currentModuleKeypath)
            let extractor = CurrentModuleExtractor()
            let moduleJSONAdapter = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let pin = JointPin(modelClass: modelClass, identifier: identifier, contextPredicate: map.contextPredicate)
            let composer = LinkedRemoteAsPrimaryRuleBuilder(pin: pin, jsonRef: jsonRef)
            let composition = try composer.buildRequestPredicateComposition()

            try appContext?.requestManager?.fetchRemote(modelClass: modelClass, contextPredicate: composition.contextPredicate, managedObjectLinker: moduleJSONAdapter, managedObjectExtractor: extractor, listener: nil)
        }
    }
}

extension ModulesTreeJSONDecoder {

    private class NextVehicleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class NextModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class CurrentModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }
}
