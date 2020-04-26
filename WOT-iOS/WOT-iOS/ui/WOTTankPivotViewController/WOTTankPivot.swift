//
//  WOTTankPivot.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot

class WOTTankPivotNodeCreator: WOTPivotNodeCreator {
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

    #warning("TO BE REFACTORED")
    private func fetchCustomPredicate() -> NSPredicate {
        let fakePredicate = NSPredicate(format: "NOT(tank_id  = nil)")
        return NSCompoundPredicate(orPredicateWithSubpredicates: [fakePredicate])
    }
}

class WOTTankPivotMetadatasource: WOTDataModelMetadatasource {
    private let permutator = WOTPivotMetadataPermutator()

    func metadataItems() -> [WOTNodeProtocol] {
        var result = [WOTNodeProtocol]()

        var templates = WOTPivotTemplates()
//        let levelPrem = templates.vehiclePremium
        let levelNati = templates.vehicleNation
        let levelType = templates.vehicleType
        let levelTier = templates.vehicleTier

        let cols = permutator.permutate(templates: [levelType, levelNati], as: .column)
        let rows = permutator.permutate(templates: [levelTier], as: .row)
        let filt = self.filters()

        result.append(contentsOf: cols)
        result.append(contentsOf: rows)
        result.append(contentsOf: filt)
        return result
    }

    func filters() -> [WOTNodeProtocol] {
        return [WOTPivotFilterNode(name: "Filter")]
    }
}

class WOTTankPivotModel: WOTPivotDataModel {
    convenience init(modelListener: WOTDataModelListener, dataProvider: WOTCoredataProviderProtocol?) {
        let fetchRequest = WOTTankPivotFetchRequest()
        let fetchController = WOTDataFetchController(nodeFetchRequestCreator: fetchRequest, dataprovider: dataProvider)

        let metadatasource = WOTTankPivotMetadatasource()
        let nodeCreator = WOTTankPivotNodeCreator()

        self.init(fetchController: fetchController,
                  modelListener: modelListener,
                  nodeCreator: nodeCreator,
                  metadatasource: metadatasource)

        self.enumerator = WOTNodeEnumerator.sharedInstance
    }

    deinit {}

    override func loadModel() {
        super.loadModel()

        do {
            try performWebRequest()
        } catch let error {
            let appManager = (UIApplication.shared.delegate as? WOTAppDelegateProtocol)?.appManager
            appManager?.logInspector?.log(ErrorLog(error, details: nil), sender: nil)
        }
    }

    private func performWebRequest() throws {
        let appManager = (UIApplication.shared.delegate as? WOTAppDelegateProtocol)?.appManager
        let requestManager = appManager?.requestManager
        try WOTWEBRequestFactory.fetchVehiclePivotData(requestManager, listener: self)
    }
}

extension WOTTankPivotModel: WOTRequestManagerListenerProtocol {
    var uuidHash: Int {
        return "WOTTankPivotModel".hashValue
    }

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didParseDataForRequest: WOTRequestProtocol, completionResultType: WOTRequestManagerCompletionResultType) {
        DispatchQueue.main.async {
            super.loadModel()
            if completionResultType == .finished || completionResultType == .noData {
                requestManager.removeListener(self)
            }
        }
    }

    func requestManager(_ requestManager: WOTRequestManagerProtocol, didStartRequest: WOTRequestProtocol) {}
}
