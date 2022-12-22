//
//  WOTTankPivot.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import WOTPivot
import ContextSDK
import WOTKit
import WOTApi

class WOTTankPivotNodeCreator: WOTPivotNodeCreator {
  #warning("Pivot configuration: collapse")
    override public var collapseToGroups: Bool { return true }

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
    var settingsDatasource: WOTTankListSettingsDatasource
    init(datasource: WOTTankListSettingsDatasource) {
        settingsDatasource = datasource
    }

    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehicles")
        result.sortDescriptors = sortDescriptors()
        result.predicate = fetchCustomPredicate()
        return result
    }

    private func sortDescriptors() -> [NSSortDescriptor] {
        let tankIdDescriptor = NSSortDescriptor(key: "tank_id", ascending: true)
        var result = settingsDatasource.sortBy
        result.append(tankIdDescriptor)
        return result
    }

    #warning("2b refactored")
    private func fetchCustomPredicate() -> NSPredicate {
        let fakePredicate = NSPredicate(format: "NOT(tank_id = nil)")
        return NSCompoundPredicate(orPredicateWithSubpredicates: [fakePredicate])
    }
}

#warning("Pivot Configuration: Columns")

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
        let filt = filters()

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
    var logInspector: LogInspectorProtocol
    var coreDataStore: DataStoreProtocol
    var requestManager: RequestManagerProtocol

    required init(modelListener: WOTDataModelListener, coreDataStore: DataStoreProtocol, requestManager: RequestManagerProtocol, logInspector: LogInspectorProtocol, settingsDatasource: WOTTankListSettingsDatasource) {
        let fetchRequest = WOTTankPivotFetchRequest(datasource: settingsDatasource)
        let fetchController = WOTDataFetchController(nodeFetchRequestCreator: fetchRequest, dataprovider: coreDataStore)
        self.coreDataStore = coreDataStore
        self.requestManager = requestManager
        self.logInspector = logInspector

        let metadatasource = WOTTankPivotMetadatasource()
        let nodeCreator = WOTTankPivotNodeCreator()

        super.init(fetchController: fetchController,
                  modelListener: modelListener,
                  nodeCreator: nodeCreator,
                  metadatasource: metadatasource)

        enumerator = WOTNodeEnumerator.sharedInstance
    }

    required init(enumerator enumer: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    required init(fetchController fc: WOTDataFetchControllerProtocol, modelListener: WOTDataModelListener, nodeCreator nc: WOTNodeCreatorProtocol, metadatasource mds: WOTDataModelMetadatasource) {
        fatalError("init(fetchController:modelListener:nodeCreator:metadatasource:) has not been implemented")
    }

    deinit {}

    override var description: String {
        return String(describing: type(of: self))
    }

    override func loadModel() {
        super.loadModel()

        do {
            try performWebRequest()
        } catch {
            logInspector.logEvent(EventError(error, details: nil), sender: nil)
        }
    }

    private func performWebRequest() throws {
        try WOTWEBRequestFactory.fetchVehiclePivotData(requestManager, listener: self)
    }
}

extension WOTTankPivotModel: RequestManagerListenerProtocol {
    var md5: String? {
        return "WOTTankPivotModel".MD5()
    }

    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType) {
        DispatchQueue.main.async {
            super.loadModel()
            if completionResultType == .finished || completionResultType == .noData {
                requestManager.removeListener(self)
            }
        }
    }

    func requestManager(_ requestManager: RequestManagerProtocol, didStartRequest: RequestProtocol) {}
}
