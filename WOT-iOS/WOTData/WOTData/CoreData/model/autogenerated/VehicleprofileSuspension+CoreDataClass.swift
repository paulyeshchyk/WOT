//
//  VehicleprofileSuspension+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileSuspension)
public class VehicleprofileSuspension: NSManagedObject {}

// MARK: - Coding Keys
extension VehicleprofileSuspension {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case tier
        case traverse_speed
        case name
        case load_limit
        case weight
        case steering_lock_angle
        case tag
    }

//    public enum RelativeKeys: String, CodingKey, CaseIterable {
//        case suspension_id
//    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

//    @objc
//    override public class func relationsKeypaths() -> [String] {
//        return RelativeKeys.allCases.compactMap { $0.rawValue }
//    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        //id was used when quering remote module
        //tag was used when parsed response vehicleprofile-suspension

        switch forType {
        case .external: return #keyPath(VehicleprofileSuspension.suspension_id)
        case .internal: return #keyPath(VehicleprofileSuspension.tag)
        }
    }
}

// MARK: - Mapping
extension VehicleprofileSuspension {
    public override func mapping(context: NSManagedObjectContext, fromJSON jSON: JSON, pkCase: PKCase, persistentStore: WOTPersistentStoreProtocol?) throws {
        try self.decode(json: jSON)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileSuspension: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.load_limit = try container.decodeAnyIfPresent(Int.self, forKey: .load_limit)?.asDecimal
        self.steering_lock_angle = try container.decodeAnyIfPresent(Int.self, forKey: .steering_lock_angle)?.asDecimal
    }
}

extension VehicleprofileSuspension {
    public class LocalJSONAdapterHelper: JSONAdapterInstanceHelper {
        var persistentStore: WOTPersistentStoreProtocol?
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
            if let suspension = fetchResult.managedObject() as? VehicleprofileSuspension {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.suspension = suspension

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
