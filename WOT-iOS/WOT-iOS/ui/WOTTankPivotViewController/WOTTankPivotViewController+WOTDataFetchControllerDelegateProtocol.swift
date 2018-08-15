//
//  WOTTankPivotViewController+WOTDataFetchControllerDelegateProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/6/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: WOTDataFetchControllerDelegateProtocol {

    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Tanks")
        result.sortDescriptors = self.sortDescriptors()
        result.predicate = self.fetchCustomPredicate()
        return result
    }

    private func sortDescriptors() -> [NSSortDescriptor]{

        let tankIdDescriptor = NSSortDescriptor(key: "tank_id", ascending: true)
        var result = WOTTankListSettingsDatasource.sharedInstance().sortBy
        result.append(tankIdDescriptor)
        return result
    }

    #warning("TO BE RECACTORED")
    private func fetchCustomPredicate() -> NSPredicate {
        let fakePredicate = NSPredicate(format: "level != %d", 600)
        return NSCompoundPredicate(orPredicateWithSubpredicates: [fakePredicate])
    }

}
