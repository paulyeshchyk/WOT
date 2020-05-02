//
//  VehicleprofileTurret+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileTurret)
public class VehicleprofileTurret: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileTurret {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case traverse_left_arc
        case traverse_speed
        case weight
        case view_range
        case hp
        case tier
        case name
        case tag
        case traverse_right_arc
    }

    @objc
    override public static func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        //id was used when quering remote module
        //tag was used when parsed response vehicleprofile-suspension
        switch forType {
        case .external: return #keyPath(VehicleprofileTurret.turret_id)
        case .internal: return #keyPath(VehicleprofileTurret.tag)
        }
    }
}

// MARK: - Mapping
extension VehicleprofileTurret {
    @objc
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileTurret: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.view_range = try container.decodeAnyIfPresent(Int.self, forKey: .view_range)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.traverse_left_arc = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_left_arc)?.asDecimal
        self.traverse_right_arc = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_right_arc)?.asDecimal
        self.traverse_speed = try container.decodeAnyIfPresent(Int.self, forKey: .traverse_speed)?.asDecimal
        self.hp = try container.decodeAnyIfPresent(Int.self, forKey: .hp)?.asDecimal
    }
}

extension VehicleprofileTurret {
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
            if let turret = fetchResult.managedObject() as? VehicleprofileTurret {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.turret = turret

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
