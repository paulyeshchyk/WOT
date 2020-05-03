//
//  VehicleprofileGun+CoreDataClass.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 4/23/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//
//

import Foundation
import CoreData

@objc(VehicleprofileGun)
public class VehicleprofileGun: NSManagedObject {}

// MARK: - PrimaryKeypathProtocol
extension VehicleprofileGun {
    override open class func predicateFormat(forType: PrimaryKeyType) -> String {
        switch forType {
        case .external:
            return "%K == %@"
        default:
            return "%K = %@"
        }
    }
}

// MARK: - Coding Keys
extension VehicleprofileGun {
    //
    public typealias Fields = FieldKeys
    public enum FieldKeys: String, CodingKey, CaseIterable {
        case move_down_arc
        case caliber
        case name
        case weight
        case move_up_arc
        case fire_rate
        case dispersion
        case tag
        case reload_time
        case tier
        case aim_time
    }

    @objc
    override public class func fieldsKeypaths() -> [String] {
        return FieldKeys.allCases.compactMap { $0.rawValue }
    }

    override public class func primaryKeyPath(forType: PrimaryKeyType) -> String {
        //id was used when quering remote module
        switch forType {
        case .external: return #keyPath(VehicleprofileGun.gun_id)
        case .internal: return #keyPath(VehicleprofileGun.tag)
        }
    }
}

// MARK: - Mapping
extension VehicleprofileGun {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        try self.decode(json: json)
    }
}

// MARK: - JSONDecoding
extension VehicleprofileGun: JSONDecoding {
    public func decodeWith(_ decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fields.self)
        //
        self.name = try container.decodeAnyIfPresent(String.self, forKey: .name)
        self.tier = try container.decodeAnyIfPresent(Int.self, forKey: .tier)?.asDecimal
        self.tag = try container.decodeAnyIfPresent(String.self, forKey: .tag)
        self.caliber = try container.decodeAnyIfPresent(Int.self, forKey: .caliber)?.asDecimal
        self.weight = try container.decodeAnyIfPresent(Int.self, forKey: .weight)?.asDecimal
        self.move_down_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_down_arc)?.asDecimal
        self.move_up_arc = try container.decodeAnyIfPresent(Int.self, forKey: .move_up_arc)?.asDecimal
        self.fire_rate = try container.decodeAnyIfPresent(Double.self, forKey: .fire_rate)?.asDecimal
        self.dispersion = try container.decodeAnyIfPresent(Double.self, forKey: .dispersion)?.asDecimal
        self.reload_time = try container.decodeAnyIfPresent(Double.self, forKey: .reload_time)?.asDecimal
        self.aim_time = try container.decodeAnyIfPresent(Double.self, forKey: .aim_time)?.asDecimal
    }
}

extension VehicleprofileGun {
    public class LocalJSONAdapterHelper: JSONAdapterInstanceHelper {
        public var primaryKeyType: PrimaryKeyType {
            return .external
        }

        private var coreDataStore: WOTCoredataStoreProtocol?
        private var objectID: NSManagedObjectID
        private var identifier: Any?

        public required init(objectID: NSManagedObjectID, identifier: Any?, coreDataStore: WOTCoredataStoreProtocol?) {
            self.objectID = objectID
            self.identifier = identifier
            self.coreDataStore = coreDataStore
        }

        public func onJSONExtraction(json: JSON) -> JSON? { return json }

        public func onInstanceDidParse(fetchResult: FetchResult) {
            let context = fetchResult.context
            if let gun = fetchResult.managedObject() as? VehicleprofileGun {
                if let vehicleProfile = context.object(with: objectID) as? Vehicleprofile {
                    vehicleProfile.gun = gun

                    coreDataStore?.stash(context: context) { error in
                        if let error = error {
                            print(error.debugDescription)
                        }
                    }
                }
            }
        }
    }
}
