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
    public static func hull(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?, callback: @escaping FetchResultCompletion) {
        guard let jSON = jSON as? JSON else {
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none, error: nil)
            callback(fetchResult)
            return
        }

        #warning("refactoring")
        mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { fetchResult in
            do {
                let armorLinker: JSONAdapterLinkerProtocol? = nil
                try mappingCoordinator?.decodingAndMapping(json: jSON, fetchResult: fetchResult, pkCase: pkCase, linker: armorLinker) { error in

                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.error = error

                    callback(finalFetchResult)
                }
            } catch let error {
                print(error)
            }
        }
    }

    @available(*, deprecated, message: "deprecated")
    public static func turret(context: NSManagedObjectContext, fromJSON jSON: Any?, pkCase: PKCase, mappingCoordinator: WOTMappingCoordinatorProtocol?, callback: @escaping FetchResultCompletion) {
        guard let jSON = jSON as? JSON else {
            let fetchResult = FetchResult(context: context, objectID: nil, predicate: nil, fetchStatus: .none, error: nil)
            callback(fetchResult)
            return
        }

        #warning("refactoring")
        mappingCoordinator?.fetchLocal(context: context, byModelClass: VehicleprofileArmor.self, pkCase: pkCase) { fetchResult in
            do {
                let turretLinker: JSONAdapterLinkerProtocol? = nil
                try mappingCoordinator?.decodingAndMapping(json: jSON, fetchResult: fetchResult, pkCase: pkCase, linker: turretLinker) { error in

                    let finalFetchResult = fetchResult.dublicate()
                    finalFetchResult.error = error
                    callback(finalFetchResult)
                }
            } catch let error {
                print(error)
            }
        }
    }
}
