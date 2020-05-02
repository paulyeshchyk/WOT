//
//  VehicleprofileAmmo+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileAmmo)
public class VehicleprofileAmmo: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileAmmo {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case type
        case stun
        case damage
        case penetration
    }

    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external: return #keyPath(VehicleprofileAmmo.type)
        case .internal: return #keyPath(VehicleprofileAmmo.type)
        }
    }
}

// MARK: - Mapping
extension VehicleprofileAmmo {
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)

        let vehicleprofileAmmoPenetrationCase = PKCase()
        vehicleprofileAmmoPenetrationCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        vehicleprofileAmmoPenetrationCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoPenetration.vehicleprofileAmmo))
        if let penetrationArray = jSON[#keyPath(VehicleprofileAmmo.penetration)] as? [Any] {
            persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileAmmoPenetration.self, pkCase: vehicleprofileAmmoPenetrationCase) { fetchResult in
                let context = fetchResult.context
                if let penetrationObject = fetchResult.managedObject() as? VehicleprofileAmmoPenetration {
                    do {
                        let penetrationHelper: JSONAdapterInstanceHelper? = nil
                        try persistentStore?.mapping(context: context, object: penetrationObject, fromArray: penetrationArray, pkCase: vehicleprofileAmmoPenetrationCase, instanceHelper: penetrationHelper) { error in
                            self.penetration = penetrationObject
                            persistentStore?.stash(context: context, hint: vehicleprofileAmmoPenetrationCase) { error in
                                if let error = error {
                                    print(error.debugDescription)
                                }
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
        let vehicleprofileAmmoDamageCase = PKCase()
        vehicleprofileAmmoDamageCase[.primary] = pkCase[.primary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))
        vehicleprofileAmmoDamageCase[.secondary] = pkCase[.secondary]?.foreignKey(byInsertingComponent: #keyPath(VehicleprofileAmmoDamage.vehicleprofileAmmo))

        if let damageArray = jSON[#keyPath(VehicleprofileAmmo.damage)] as? [Any] {
            persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileAmmoDamage.self, pkCase: vehicleprofileAmmoDamageCase) { fetchResult in

                let context = fetchResult.context
                if let damageObject = fetchResult.managedObject() as? VehicleprofileAmmoDamage {
                    do {
                        let damageHelper: JSONAdapterInstanceHelper? = nil
                        try persistentStore?.mapping(context: context, object: damageObject, fromArray: damageArray, pkCase: vehicleprofileAmmoDamageCase, instanceHelper: damageHelper) { error in
                            self.damage = damageObject
                            persistentStore?.stash(context: context, hint: vehicleprofileAmmoPenetrationCase) { error in
                                if let error = error {
                                    print(error.debugDescription)
                                }
                            }
                        }
                    } catch let error {
                        print(error)
                    }
                }
            }
        }
    }

    convenience init?(json: JSON?, into context: NSManagedObjectContext, parentPrimaryKey: WOTPrimaryKey?, forRequest: WOTRequestProtocol, persistentStore: WOTPersistentStoreProtocol?) {
        guard let json = json, let entityDescription = VehicleprofileAmmo.entityDescription(context) else { return nil }
        self.init(entity: entityDescription, insertInto: context)

        let pkCase = PKCase()
        pkCase[.primary] = parentPrimaryKey
        do {
            try persistentStore?.mapping(context: context, object: self, fromJSON: json, pkCase: pkCase, instanceHelper: nil) { _ in
            }
        } catch let error {
            print(error)
        }
    }
}

// MARK: - JSONDecoding
extension VehicleprofileAmmo: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
}

extension VehicleprofileAmmo {
    public class LocalJSONAdapterHelper: JSONAdapterInstanceHelper {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var persistentStore: WOTPersistentStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, persistentStore: WOTPersistentStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.persistentStore = persistentStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let ammo = fetchResult.managedObject() as? VehicleprofileAmmo {
                if let ammoList = context.object(with: objectID) as? VehicleprofileAmmoList {
                    ammoList.addToVehicleprofileAmmo(ammo)

                    persistentStore?.stash(context: context, hint: nil) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
