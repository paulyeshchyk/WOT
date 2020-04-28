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
    public static func hull(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping ContextAnyObjectErrorCompletion) {
        guard let jSON = jSON as? JSON else {
            callback(context, nil, nil)
            return
        }

        do {
            try persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) {context, managedObjectID, _ in
                do {
                    guard let managedObjectID = managedObjectID else {
                        print("nil")
                        return
                    }
                    let newObject = context.object(with: managedObjectID)

                    try persistentStore?.mapping(context: context, object: newObject, fromJSON: jSON, pkCase: pkCase)
                    callback(context, managedObjectID, nil)
                } catch let error {
                    print(error)
                }
            }
        } catch let error {
            print(error)
        }
    }

    public static func turret(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?, callback: @escaping ContextAnyObjectErrorCompletion) {
        guard let jSON = jSON as? JSON else {
            callback(context, nil, nil)
            return
        }

        do {
            try persistentStore?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { context, managedObjectID, _ in
                do {
                    guard let managedObjectID = managedObjectID else {
                        print("not found")
                        return
                    }
                    let newObject = context.object(with: managedObjectID)

                    try persistentStore?.mapping(context: context, object: newObject, fromJSON: jSON, pkCase: pkCase)
                    callback(context, managedObjectID, nil)
                } catch let error {
                    print(error)
                }
            }
        } catch let error {
            print(error)
        }
    }
}
