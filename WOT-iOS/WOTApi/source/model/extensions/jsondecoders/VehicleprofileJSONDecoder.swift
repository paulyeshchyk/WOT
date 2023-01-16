//
//  VehicleprofileJSONDecoder.swift
//  WOTApi
//
//  Created by Paul on 16.01.23.
//

// MARK: - VehicleprofileJSONDecoder

class VehicleprofileJSONDecoder: JSONDecoderProtocol {
    private weak var appContext: JSONDecoderProtocol.Context?
    required init(appContext: JSONDecoderProtocol.Context?) {
        self.appContext = appContext
    }

    var managedObject: ManagedAndDecodableObjectType?

    func decode(using map: JSONMapProtocol, appContext: JSONDecoderProtocol.Context?, forDepthLevel: DecodingDepthLevel?) throws {
        //
        let element = try map.data(ofType: JSON.self)
        try managedObject?.decode(decoderContainer: element)
        let jsonRef = try JSONRef(element: element, modelClass: Vehicleprofile.self)
        //

        // MARK: - Link items

        var parentJSonRefs = [JSONRefProtocol]()
        parentJSonRefs.append(contentsOf: map.contextPredicate.jsonRefs)
        parentJSonRefs.append(jsonRef)

        let tank_id = element?[#keyPath(Vehicleprofile.tank_id)] as? NSDecimalNumber

        // MARK: - AmmoList

        let ammoKeypath = #keyPath(Vehicleprofile.ammo)
        if let jsonArray = element?[ammoKeypath] as? [JSON] {
            let foreignSelectKey = #keyPath(VehicleprofileAmmoList.vehicleprofile)
            let modelClass = VehicleprofileAmmoList.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: parentJSonRefs)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: ammoKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(array: jsonArray, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noAmmoList(tank_id)), sender: self)
        }

        // MARK: - Armor

        let armorKeypath = #keyPath(Vehicleprofile.armor)
        if let jsonElement = element?[armorKeypath] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileModule.vehicleprofile)
            let modelClass = VehicleprofileArmorList.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: parentJSonRefs)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: armorKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noArmor(tank_id)), sender: self)
        }

        // MARK: - Module

        let modulesKeypath = #keyPath(Vehicleprofile.modules)
        if let jsonElement = element?[modulesKeypath] as? JSON {
            let foreignSelectKey = #keyPath(VehicleprofileModule.vehicleprofile)
            let modelClass = VehicleprofileModule.self
            let composer = ForeignAsPrimaryRuleBuilder(jsonMap: map, foreignSelectKey: foreignSelectKey, jsonRefs: parentJSonRefs)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: modulesKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noModule(tank_id)), sender: self)
        }

        // MARK: - Engine

        let engineKeypath = #keyPath(Vehicleprofile.engine)
        if let jsonElement = element?[engineKeypath] as? JSON {
            let keypath = VehicleprofileEngine.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileEngine.self
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: engineKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noEngine(tank_id)), sender: self)
        }

        // MARK: - Gun

        let gunKeypath = #keyPath(Vehicleprofile.gun)
        if let jsonElement = element?[gunKeypath] as? JSON {
            let modelClass = VehicleprofileGun.self
            let keypath = VehicleprofileGun.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: gunKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noGun(tank_id)), sender: self)
        }

        // MARK: - Suspension

        let suspensionKeypath = #keyPath(Vehicleprofile.suspension)
        if let jsonElement = element?[suspensionKeypath] as? JSON {
            let keypath = VehicleprofileSuspension.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileSuspension.self
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: suspensionKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noSuspension(tank_id)), sender: self)
        }

        // MARK: - Turret

        let turretKeypath = #keyPath(Vehicleprofile.turret)
        if let jsonElement = element?[turretKeypath] as? JSON {
            let keypath = VehicleprofileTurret.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileTurret.self
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: turretKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noTurret(tank_id)), sender: self)
        }

        // MARK: - Radio

        let radioKeypath = #keyPath(Vehicleprofile.radio)
        if let jsonElement = element?[radioKeypath] as? JSON {
            let keypath = VehicleprofileRadio.primaryKeyPath(forType: .internal)
            let drivenObjectID = jsonElement[keypath]
            let modelClass = VehicleprofileRadio.self
            let pin = JointPin(modelClass: modelClass, identifier: drivenObjectID, contextPredicate: nil)
            let composer = RootTagRuleBuilder(pin: pin)
            let composition = try composer.buildRequestPredicateComposition()
            let socket = JointSocket(managedRef: managedObject?.managedRef, identifier: composition.objectIdentifier, keypath: radioKeypath)
            let managedObjectLinker = ManagedObjectLinker(modelClass: modelClass, socket: socket)
            let jsonMap = try JSONMap(element: jsonElement, predicate: composition.contextPredicate)
            let decodingDepthLevel = forDepthLevel?.next

            JSONSyndicate.decodeAndLink(appContext: appContext, jsonMap: jsonMap, modelClass: modelClass, managedObjectLinker: managedObjectLinker, decodingDepthLevel: decodingDepthLevel, completion: { _, error in
                if let error = error {
                    appContext?.logInspector?.log(.warning(error: error), sender: self)
                }
            })
        } else {
            appContext?.logInspector?.log(.warning(error: VehicleProfileMappingError.noTurret(tank_id)), sender: self)
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

// MARK: - VehicleProfileMappingError

public enum VehicleProfileMappingError: Error, CustomStringConvertible {
    case noAmmoList(NSDecimalNumber?)
    case noArmor(NSDecimalNumber?)
    case noModule(NSDecimalNumber?)
    case noEngine(NSDecimalNumber?)
    case noGun(NSDecimalNumber?)
    case noSuspension(NSDecimalNumber?)
    case noTurret(NSDecimalNumber?)
    case noRadio(NSDecimalNumber?)

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
        }
    }
}
