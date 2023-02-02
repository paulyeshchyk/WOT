//
//  VehicleprofileJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileJSONDecoder

class VehicleprofileJSONDecoder: JSONDecoderProtocol {

    private let appContext: Context

    required init(appContext: Context) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)

        // MARK: - do check decodingDepth

        if decodingDepthLevel?.maxReached() ?? false {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.maxDecodingDepthLevelReached(decodingDepthLevel)), sender: self)
            return
        }

        // MARK: - relation mapping

        let jsonRef = try JSONRef(data: element, modelClass: Vehicleprofile.self)

        // MARK: - Link items

        var parentJSonRefs = [JSONRefProtocol]()
        parentJSonRefs.append(contentsOf: map.contextPredicate.jsonRefs)
        parentJSonRefs.append(jsonRef)

        // MARK: - AmmoList

        fetch_element(keypath: #keyPath(Vehicleprofile.ammo),
                      modelClass: VehicleprofileAmmoList.self,
                      parentKey: #keyPath(VehicleprofileAmmoList.vehicleprofile),
                      element: element,
                      contextPredicate: map.contextPredicate,
                      parentJSonRefs: parentJSonRefs,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - ArmorList

        fetch_element(keypath: #keyPath(Vehicleprofile.armor),
                      modelClass: VehicleprofileArmorList.self,
                      parentKey: #keyPath(VehicleprofileModule.vehicleprofile),
                      element: element,
                      contextPredicate: map.contextPredicate,
                      parentJSonRefs: parentJSonRefs,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Module

        fetch_element(keypath: #keyPath(Vehicleprofile.modules),
                      modelClass: VehicleprofileModule.self,
                      parentKey: #keyPath(VehicleprofileModule.vehicleprofile),
                      element: element,
                      contextPredicate: map.contextPredicate,
                      parentJSonRefs: parentJSonRefs,
                      decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Engine

        fetch_module(keypath: #keyPath(Vehicleprofile.engine),
                     idKeypath: VehicleprofileEngine.primaryKeyPath(forType: .internal),
                     modelClass: VehicleprofileEngine.self,
                     element: element,
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Gun

        fetch_module(keypath: #keyPath(Vehicleprofile.gun),
                     idKeypath: VehicleprofileGun.primaryKeyPath(forType: .internal),
                     modelClass: VehicleprofileGun.self,
                     element: element,
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Suspension

        fetch_module(keypath: #keyPath(Vehicleprofile.suspension),
                     idKeypath: VehicleprofileSuspension.primaryKeyPath(forType: .internal),
                     modelClass: VehicleprofileSuspension.self,
                     element: element,
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Turret

        fetch_module(keypath: #keyPath(Vehicleprofile.turret),
                     idKeypath: VehicleprofileTurret.primaryKeyPath(forType: .internal),
                     modelClass: VehicleprofileTurret.self,
                     element: element,
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)

        // MARK: - Radio

        fetch_module(keypath: #keyPath(Vehicleprofile.radio),
                     idKeypath: VehicleprofileRadio.primaryKeyPath(forType: .internal),
                     modelClass: VehicleprofileRadio.self,
                     element: element,
                     decodingDepthLevel: decodingDepthLevel?.nextDepthLevel)
    }

    private func fetch_element(keypath: AnyHashable, modelClass: ModelClassType, parentKey: String, element: JSON, contextPredicate: ContextPredicateProtocol, parentJSonRefs: [JSONRefProtocol], decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileJSONDecoderErrors.noManagedRef
            }
            guard let element = element[keypath] else {
                throw VehicleprofileJSONDecoderErrors.elementNotFound(keypath)
            }

            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: keypath)

            let composerInput = ComposerInput()
            composerInput.contextPredicate = contextPredicate
            composerInput.parentKey = parentKey
            composerInput.parentJSONRefs = parentJSonRefs
            let composer = ForeignKey_Composer()
            let contextPredicate = try composer.build(composerInput)

            let jsonMap = try JSONMap(data: element, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }

    private func fetch_module(keypath: AnyHashable, idKeypath: AnyHashable, modelClass: ModelClassType, element: JSON, decodingDepthLevel: DecodingDepthLevel?) {
        do {
            guard let element = element[keypath] as? JSON else {
                throw VehicleprofileJSONDecoderErrors.elementNotFound(keypath)
            }
            guard let module_id = element[idKeypath] else {
                throw VehicleprofileJSONDecoderErrors.idNotFound(idKeypath)
            }

            guard let managedRef = try managedObject?.managedRef() else {
                throw VehicleprofileJSONDecoderErrors.noManagedRef
            }

            let socket = JointSocket(managedRef: managedRef, identifier: module_id, keypath: keypath)
            let pin = JointPin(modelClass: modelClass, identifier: module_id, contextPredicate: nil)

            let composerInput = ComposerInput()
            composerInput.pin = pin
            let composer = PrimaryKey_Composer()
            let contextPredicate = try composer.build(composerInput)

            let jsonMap = try JSONMap(data: element, predicate: contextPredicate)

            let uow = UOWDecodeAndLinkMaps(appContext: appContext)
            uow.maps = [jsonMap]
            uow.modelClass = modelClass
            uow.socket = socket
            uow.decodingDepthLevel = decodingDepthLevel

            appContext.uowManager.run(unit: uow, listenerCompletion: { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.error(error), sender: self)
                }
            })
        } catch {
            appContext.logInspector?.log(.warning(error: error), sender: self)
        }
    }
}

extension Vehicleprofile {

    private class ArmorListExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class EngineExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class GunExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    public class RadioExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class TurretManagedObjectCreator: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class AmmoListExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class SuspensionExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }

    private class ModuleExtractor: ManagedObjectExtractable {
        public var linkerPrimaryKeyType: PrimaryKeyType { return .external }
        public var jsonKeyPath: KeypathType? { nil }
    }
}

// MARK: - VehicleprofileJSONDecoder.VehicleprofileJSONDecoderErrors

extension VehicleprofileJSONDecoder {

    public enum VehicleprofileJSONDecoderErrors: Error, CustomStringConvertible {
        case noAmmoList(NSDecimalNumber?)
        case noArmor(NSDecimalNumber?)
        case noModule(NSDecimalNumber?)
        case noEngine(NSDecimalNumber?)
        case noGun(NSDecimalNumber?)
        case noSuspension(NSDecimalNumber?)
        case noTurret(NSDecimalNumber?)
        case noRadio(NSDecimalNumber?)
        case maxDecodingDepthLevelReached(DecodingDepthLevel?)
        case noManagedRef
        case elementNotFound(AnyHashable)
        case idNotFound(AnyHashable)

        public var description: String {
            switch self {
            case .noAmmoList(let profile): return "[\(type(of: self))]: No ammo list in profile with id: \(profile ?? -1)"
            case .noArmor(let profile): return "[\(type(of: self))]: No armor in profile with id: \(profile ?? -1)"
            case .noModule(let profile): return "[\(type(of: self))]: No module in profile with id: \(profile ?? -1)"
            case .noEngine(let profile): return "[\(type(of: self))]: No engine in profile with id: \(profile ?? -1)"
            case .noGun(let profile): return "[\(type(of: self))]: No gun in profile with id: \(profile ?? -1)"
            case .noSuspension(let profile): return "[\(type(of: self))]: No suspension in profile with id: \(profile ?? -1)"
            case .noTurret(let profile): return "[\(type(of: self))]: No turret in profile with id: \(profile ?? -1)"
            case .noRadio(let profile): return "[\(type(of: self))]: No radio in profile with id: \(profile ?? -1)"
            case .maxDecodingDepthLevelReached(let level): return "[\(type(of: self))]: Max decoding level reached \(level?.rawValue ?? -1)"
            case .noManagedRef: return "[\(type(of: self))]: No managed ref"
            case .elementNotFound(let keypath): return "[\(type(of: self))]: Element not found for (\(keypath))"
            case .idNotFound(let keypath): return "[\(type(of: self))]: id not found for (\(keypath))"
            }
        }
    }
}
