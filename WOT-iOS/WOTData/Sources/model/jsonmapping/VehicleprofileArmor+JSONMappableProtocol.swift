//
//  VehicleprofileArmor+JSONMappableProtocol.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/4/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTKit
import CoreData

// MARK: - JSONMappableProtocol

extension VehicleprofileArmor {
    public override func mapping(json: JSON, context: NSManagedObjectContext, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?) throws {
        //
        try self.decode(json: json)
        //
    }
}

extension VehicleprofileArmor {
    @available(*, deprecated, message: "deprecated")
    public static func hull(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let jSON = jSON as? JSON else {
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none)
            #warning("NO JSON error used")
            callback(fetchResult, nil)
            return
        }

        #warning("refactoring")
        mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { fetchResult, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                return
            }
            let armorLinker: JSONAdapterLinkerProtocol? = nil
            mappingCoordinator?.decodingAndMapping(json: jSON, fetchResult: fetchResult, pkCase: pkCase, linker: armorLinker, completion: callback)
        }
    }

    @available(*, deprecated, message: "deprecated")
    public static func turret(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?, callback: @escaping FetchResultErrorCompletion) {
        guard let jSON = jSON as? JSON else {
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none)
            #warning("NO JSON error used")
            callback(fetchResult, nil)
            return
        }

        #warning("refactoring")
        mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { fetchResult, error in
            if let error = error {
                mappingCoordinator?.logEvent(EventError(error, details: nil), sender: nil)
                return
            }
            let turretLinker: JSONAdapterLinkerProtocol? = nil
            mappingCoordinator?.decodingAndMapping(json: jSON, fetchResult: fetchResult, pkCase: pkCase, linker: turretLinker, completion: callback)
        }
    }
}
