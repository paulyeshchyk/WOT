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
                if let managedObjectID = fetchResult.objectID, let penetrationObject = context.object(with: managedObjectID) as? VehicleprofileAmmoPenetration {
                    do {
                        try persistentStore?.mapping(context: context, object: penetrationObject, fromArray: penetrationArray, pkCase: vehicleprofileAmmoPenetrationCase)
                        self.penetration = penetrationObject
                        persistentStore?.stash(context: context, hint: vehicleprofileAmmoPenetrationCase)
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
                if let managedObjectID = fetchResult.objectID, let damageObject = context.object(with: managedObjectID) as? VehicleprofileAmmoDamage {
                    do {
                        try persistentStore?.mapping(context: context, object: damageObject, fromArray: damageArray, pkCase: vehicleprofileAmmoDamageCase)
                        self.damage = damageObject
                        persistentStore?.stash(context: context, hint: vehicleprofileAmmoPenetrationCase)
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
            try persistentStore?.mapping(context: context, object: self, fromJSON: json, pkCase: pkCase)
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
