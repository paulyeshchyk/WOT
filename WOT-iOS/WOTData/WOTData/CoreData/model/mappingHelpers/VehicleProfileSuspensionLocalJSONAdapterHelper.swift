//
//  VehicleProfileSuspensionLocalJSONAdapterHelper.swift
//  WOTData
//
//  Created by Pavel Yeshchyk on 5/2/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import CoreData

public class VehicleProfileSuspensionLocalJSONAdapterHelper: JSONAdapterInstanceHelper {
    var persistentStore: WOTPersistentStoreProtocol?
    private var objectID: NSManagedObjectID
    private var identifier: Any?

    public required init(objectID: NSManagedObjectID, identifier: Any?) {
        self.objectID = objectID
        self.identifier = identifier
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
