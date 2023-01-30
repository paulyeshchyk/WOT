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

        guard let managedRef = try managedObject?.managedRef() else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noManagedRef), sender: self)
            return
        }

        // MARK: - relation mapping

        let jsonRef = try JSONRef(data: element, modelClass: Vehicleprofile.self)

        // MARK: - Link items

        var parentJSonRefs = [JSONRefProtocol]()
        parentJSonRefs.append(contentsOf: map.contextPredicate.jsonRefs)
        parentJSonRefs.append(jsonRef)

        let tank_id = element[#keyPath(Vehicleprofile.tank_id)] as? NSDecimalNumber

        // MARK: - AmmoList

        let ammoKeypath = #keyPath(Vehicleprofile.ammo)
        if let jsonArray = element[ammoKeypath] as? [JSON] {
            let modelClass = VehicleprofileAmmoList.self
            let foreignSelectKey = #keyPath(VehicleprofileAmmoList.vehicleprofile)
            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: ammoKeypath)
            try fetch_element(modelClass: modelClass,
                              parentKey: foreignSelectKey,
                              jsonData: jsonArray,
                              parentContextPredicate: map.contextPredicate,
                              socket: socket,
                              parentJSonRefs: parentJSonRefs,
                              decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noAmmoList(tank_id)), sender: self)
        }

        // MARK: - Armor

        let armorKeypath = #keyPath(Vehicleprofile.armor)
        if let jsonElement = element[armorKeypath] as? JSON {
            let modelClass = VehicleprofileArmorList.self
            let foreignSelectKey = #keyPath(VehicleprofileModule.vehicleprofile)
            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: armorKeypath)
            try fetch_element(modelClass: modelClass,
                              parentKey: foreignSelectKey,
                              jsonData: jsonElement,
                              parentContextPredicate: map.contextPredicate,
                              socket: socket,
                              parentJSonRefs: parentJSonRefs,
                              decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noArmor(tank_id)), sender: self)
        }

        // MARK: - Module

        let modulesKeypath = #keyPath(Vehicleprofile.modules)
        if let jsonElement = element[modulesKeypath] as? JSON {
            let modelClass = VehicleprofileModule.self
            let foreignSelectKey = #keyPath(VehicleprofileModule.vehicleprofile)
            let socket = JointSocket(managedRef: managedRef, identifier: nil, keypath: modulesKeypath)
            try fetch_element(modelClass: modelClass,
                              parentKey: foreignSelectKey,
                              jsonData: jsonElement,
                              parentContextPredicate: map.contextPredicate,
                              socket: socket,
                              parentJSonRefs: parentJSonRefs,
                              decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noModule(tank_id)), sender: self)
        }

        // MARK: - Engine

        let engineKeypath = #keyPath(Vehicleprofile.engine)
        if let jsonElement = element[engineKeypath] as? JSON {
            let modelClass = VehicleprofileEngine.self
            let idkeypath = VehicleprofileEngine.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[idkeypath]
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let socket = JointSocket(managedRef: managedRef, identifier: pin.identifier, keypath: engineKeypath)
            try fetch_module(pin: pin,
                             jsonData: jsonElement,
                             socket: socket,
                             decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noEngine(tank_id)), sender: self)
        }

        // MARK: - Gun

        let gunKeypath = #keyPath(Vehicleprofile.gun)
        if let jsonElement = element[gunKeypath] as? JSON {
            let modelClass = VehicleprofileGun.self
            let idkeypath = VehicleprofileGun.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[idkeypath]
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let socket = JointSocket(managedRef: managedRef, identifier: pin.identifier, keypath: gunKeypath)
            try fetch_module(pin: pin,
                             jsonData: jsonElement,
                             socket: socket,
                             decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noGun(tank_id)), sender: self)
        }

        // MARK: - Suspension

        let suspensionKeypath = #keyPath(Vehicleprofile.suspension)
        if let jsonElement = element[suspensionKeypath] as? JSON {
            let modelClass = VehicleprofileSuspension.self
            let idkeypath = VehicleprofileSuspension.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[idkeypath]
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let socket = JointSocket(managedRef: managedRef, identifier: pin.identifier, keypath: suspensionKeypath)
            try fetch_module(pin: pin,
                             jsonData: jsonElement,
                             socket: socket,
                             decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noSuspension(tank_id)), sender: self)
        }

        // MARK: - Turret

        let turretKeypath = #keyPath(Vehicleprofile.turret)
        if let jsonElement = element[turretKeypath] as? JSON {
            let modelClass = VehicleprofileTurret.self
            let idkeypath = VehicleprofileTurret.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[idkeypath]
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let socket = JointSocket(managedRef: managedRef, identifier: pin.identifier, keypath: turretKeypath)
            try fetch_module(pin: pin,
                             jsonData: jsonElement,
                             socket: socket,
                             decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noTurret(tank_id)), sender: self)
        }

        // MARK: - Radio

        let radioKeypath = #keyPath(Vehicleprofile.radio)
        if let jsonElement = element[radioKeypath] as? JSON {
            let modelClass = VehicleprofileRadio.self
            let idkeypath = VehicleprofileRadio.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[idkeypath]
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let socket = JointSocket(managedRef: managedRef, identifier: pin.identifier, keypath: radioKeypath)
            try fetch_module(pin: pin,
                             jsonData: jsonElement,
                             socket: socket,
                             decodingDepthLevel: decodingDepthLevel)
        } else {
            appContext.logInspector?.log(.warning(error: VehicleprofileJSONDecoderErrors.noTurret(tank_id)), sender: self)
        }
    }

    func fetch_element(modelClass: ModelClassType, parentKey: String, jsonData: Any, parentContextPredicate: ContextPredicateProtocol, socket: JointSocketProtocol, parentJSonRefs: [JSONRefProtocol], decodingDepthLevel: DecodingDepthLevel?) throws {
        let composerInput = ComposerInput()
        composerInput.contextPredicate = parentContextPredicate
        composerInput.parentKey = parentKey
        composerInput.parentJSONRefs = parentJSonRefs
        let composer = ForeignKey_Composer()
        let contextPredicate = try composer.build(composerInput)

        let jsonMap = try JSONMap(data: jsonData, predicate: contextPredicate)

        let uow = UOWDecodeAndLinkMaps(appContext: appContext)
        uow.maps = [jsonMap]
        uow.modelClass = modelClass
        uow.socket = socket
        uow.decodingDepthLevel = decodingDepthLevel

        appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
    }

    private func fetch_module(pin: JointPinProtocol, jsonData: JSON, socket: JointSocketProtocol, decodingDepthLevel: DecodingDepthLevel?) throws {
        let composerInput = ComposerInput()
        composerInput.pin = pin
        let composer = PrimaryKey_Composer()
        let contextPredicate = try composer.build(composerInput)

        let jsonMap = try JSONMap(data: jsonData, predicate: contextPredicate)

        let uow = UOWDecodeAndLinkMaps(appContext: appContext)
        uow.maps = [jsonMap]
        uow.modelClass = pin.modelClass
        uow.socket = socket
        uow.decodingDepthLevel = decodingDepthLevel

        appContext.uowManager.run(unit: uow, listenerCompletion: { _ in })
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
            }
        }
    }
}
