//
//  WOTTankPivot.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

public class WOTTankPivotNodeCreator: WOTPivotNodeCreator {

    override public var collapseToGroups: Bool { return false }

    override public var useEmptyNode: Bool { return false }

    override public func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {
        let name = (fetchedObject as? Vehicles)?.name ?? ""
        let type = (fetchedObject as? Vehicles)?.type ?? ""
        let color = WOTNodeFactory.typeColors()[type] as? UIColor
        let result = WOTPivotDataNode(name: name)
        result.predicate = byPredicate
        result.data1 = fetchedObject
        result.dataColor = color
        return result
    }
}

class WOTTankPivotFetchRequest: WOTDataFetchControllerDelegateProtocol {

    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehicles")
        result.sortDescriptors = sortDescriptors()
        result.predicate = fetchCustomPredicate()
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

class WOTTankPivotMetadatasource: WOTDataModelMetadatasource {

    func metadataItems() -> [WOTNodeProtocol] {

        var result = [WOTPivotNodeProtocol]()

        var templates = WOTPivotTemplates()
//        let levelPrem = templates.vehiclePremium
        let levelNati = templates.vehicleNation
        let levelType = templates.vehicleType
        let levelTier = templates.vehicleTier

        let permutator = WOTPivotMetadataPermutator()

        let cols = permutator.permutate(templates: [levelType, levelNati], as: .column)
        let rows = permutator.permutate(templates: [levelTier], as: .row)
        let filt = self.filters()

        result.append(contentsOf: cols)
        result.append(contentsOf: rows)
        result.append(contentsOf: filt)
        return result
    }

    func filters () -> [WOTPivotNodeProtocol] {
        return [WOTPivotFilterNode(name: "Filter")]
    }
}


public class WOTTankPivotModel: WOTPivotDataModel {

    convenience init(modelListener: WOTDataModelListener) {
        
        let fetchRequest = WOTTankPivotFetchRequest()
        let fetchController = WOTDataFetchController(nodeFetchRequestCreator: fetchRequest)
        
        let metadatasource = WOTTankPivotMetadatasource()
        let nodeCreator = WOTTankPivotNodeCreator()

        self.init(fetchController: fetchController,
                  modelListener: modelListener,
                  nodeCreator: nodeCreator,
                  metadatasource: metadatasource)
        
        self.enumerator = WOTNodeEnumerator.sharedInstance

    }
    
}
