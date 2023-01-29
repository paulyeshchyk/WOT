//
//  VehiclesJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehiclesJSONDecoder

class VehiclesJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using jsonMap: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try jsonMap.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehiclesJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        let jsonRef = try JSONRef(data: element, modelClass: Vehicles.self)
        let tank_id = element?[#keyPath(Vehicles.tank_id)] as? NSDecimalNumber

        // MARK: - ModulesTree

        if let modulesTreeJSON = element?[#keyPath(Vehicles.modules_tree)] as? JSON {
            var parentJSONRefs = jsonMap.contextPredicate.jsonRefs
            parentJSONRefs.append(jsonRef)

            let composer = VehiclesModuleTreeBuilder(jsonMap: jsonMap, jsonRefs: parentJSONRefs)
            let contextPredicate = try composer.buildRequestPredicateComposition()

            for key in modulesTreeJSON.keys {
                if let jsonElement = modulesTreeJSON[key] as? JSON {
                    let module_id = jsonElement[#keyPath(ModulesTree.module_id)]

                    let composer = VehiclesModuleBuilder(requestPredicate: contextPredicate, module_id: module_id)
                    let contextPredicate = try composer.buildRequestPredicateComposition()
                    let keypath = #keyPath(ModulesTree.next_modules)
                    let modelClass = ModulesTree.self
                    let managedRef = try managedObject?.managedRef()

                    let socket = JointSocket(managedRef: managedRef!, identifier: module_id, keypath: keypath)
                    let jsonMap = try JSONMap(data: jsonElement, predicate: contextPredicate)

                    #warning("move out of Decoder")

                    let uow = UOWDecodeAndLinkMaps(appContext: appContext)
                    uow.maps = [jsonMap]
                    uow.modelClass = modelClass
                    uow.socket = socket
                    uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

                    appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })

                } else {
                    appContext.logInspector?.log(.warning(error: VehiclesJSONDecoderErrors.moduleTreeNotFound(tank_id)), sender: self)
                }
            }
        } else {
            appContext.logInspector?.log(.warning(error: VehiclesJSONDecoderErrors.moduleTreeNotFound(tank_id)), sender: self)
        }

        // MARK: - DefaultProfile

        let defaultProfileKeypath = #keyPath(Vehicles.default_profile)
        if let jsonElement = element?[defaultProfileKeypath] as? JSON {
            let foreignSelectKey = #keyPath(Vehicleprofile.vehicles)
            let modelClass = Vehicleprofile.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: jsonMap, foreignSelectKey: foreignSelectKey, jsonRefs: [])
            let contextPredicate = try composer.buildRequestPredicateComposition()
            let managedRef = try managedObject?.managedRef()

            let socket = JointSocket(managedRef: managedRef!, identifier: nil, keypath: defaultProfileKeypath)
            let jsonMap = try JSONMap(data: jsonElement, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel?.nextDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })

        } else {
            appContext.logInspector?.log(.warning(error: VehiclesJSONDecoderErrors.profileNotFound(tank_id)), sender: self)
        }
    }
}

extension VehiclesJSONDecoder {
    private func modulesTreeMapping(modulesTreeJSON _: JSON?, jsonRef _: JSONRefProtocol, jsonMap _: JSONMapProtocol, appContext _: Context?) throws {}
}

extension VehiclesJSONDecoder {

    public class DefaultProfileExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class ModulesTreeExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }

    }
}

// MARK: - %t + VehiclesJSONDecoder.VehiclesJSONDecoderErrors

extension VehiclesJSONDecoder {

    enum VehiclesJSONDecoderErrors: Error, CustomStringConvertible {
        case notAJSON
        case passedInvalidModuleTreeJSON(NSDecimalNumber?)
        case passedInvalidSubModuleJSON
        case passedInvalidModuleId
        case profileNotFound(NSDecimalNumber?)
        case moduleTreeNotFound(NSDecimalNumber?)
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)

        public var description: String {
            switch self {
            case .notAJSON: return "[\(type(of: self))]: Not a JSON"
            case .passedInvalidModuleTreeJSON(let profileID): return "[\(type(of: self))]: Passed invalid module tree json for \(profileID ?? -1)"
            case .passedInvalidSubModuleJSON: return "[\(type(of: self))]: Passed invalid submodule json"
            case .passedInvalidModuleId: return "[\(type(of: self))]: Passed invalid module id"
            case .profileNotFound(let id): return "[\(type(of: self))]: Profile is not defined in json for \(id ?? -1)"
            case .moduleTreeNotFound(let id): return "[\(type(of: self))]: Module tree is not defined in json for \(id ?? -1)"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            }
        }
    }
}
