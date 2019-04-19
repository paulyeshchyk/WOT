//
//  WOTTankPivotViewController+WOTDataFetchControllerDelegateProtocol.swift
//  WOT-iOS
//
//  Created on 8/6/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import WOTPivot

extension WOTTankPivotViewController: WOTDataFetchControllerDelegateProtocol {

    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehicles")
        result.sortDescriptors = self.sortDescriptors()
        result.predicate = self.fetchCustomPredicate()
        return result
    }

    private func sortDescriptors() -> [NSSortDescriptor] {

        let tankIdDescriptor = NSSortDescriptor(key: "tank_id", ascending: true)
        var result = WOTTankListSettingsDatasource.sharedInstance().sortBy
        result.append(tankIdDescriptor)
        return result
    }

    //TODO: "TO BE RECACTORED"
    private func fetchCustomPredicate() -> NSPredicate {
        let fakePredicate = NSPredicate(format: "NOT(tank_id  = nil)")
        return NSCompoundPredicate(orPredicateWithSubpredicates: [fakePredicate])
    }

}
