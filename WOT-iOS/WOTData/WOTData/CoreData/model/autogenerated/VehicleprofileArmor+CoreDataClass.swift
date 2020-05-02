//
//  VehicleprofileArmor+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileArmor)
public class VehicleprofileArmor: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileArmor {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case front
        case sides
        case rear
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }
}

// MARK: - Mapping
extension VehicleprofileArmor {
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileArmor: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.front = try container.decodeAnyIfPresent(Int.self, forKey: .front)?.asDecimal
        self.sides = try container.decodeAnyIfPresent(Int.self, forKey: .sides)?.asDecimal
        self.rear = try container.decodeAnyIfPresent(Int.self, forKey: .rear)?.asDecimal
    }
}

extension VehicleprofileArmor {
    @available(*, deprecated, message: "deprecated")
    public static func hull(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping FetchResultCompletion) {
        guard let jSON = jSON as? JSON else {
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none, error: nil)
            callback(fetchResult)
            return
        }

        persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { fetchResult in
            do {
                let context = fetchResult.context
                let newObject = fetchResult.managedObject()

                let armorInstanceHelper: JSONAdapterInstanceHelper? = nil
                try persistentStore?.mapping(context: context, object: newObject, fromJSON: jSON, pkCase: pkCase, instanceHelper: armorInstanceHelper) { error in
                    let fetchResult = FetchResult(context: context, objectID: newObject.objectID, predicate: nil, fetchStatus: .none, error: nil)
                    callback(fetchResult)
                }
            } catch let error {
                print(error)
            }
        }
    }

    public static func turret(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping FetchResultCompletion) {
        guard let jSON = jSON as? JSON else {
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none, error: nil)
            callback(fetchResult)
            return
        }

        persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { fetchResult in
            do {
                let context = fetchResult.context
                let newObject = fetchResult.managedObject()

                let turretInstanceHelper: JSONAdapterInstanceHelper? = nil
                try persistentStore?.mapping(context: context, object: newObject, fromJSON: jSON, pkCase: pkCase, instanceHelper: turretInstanceHelper) { error in
                    let fetchResult = FetchResult(context: context, objectID: newObject.objectID, predicate: nil, fetchStatus: .none, error: nil)
                    callback(fetchResult)
                }
            } catch let error {
                print(error)
            }
        }
    }
}
