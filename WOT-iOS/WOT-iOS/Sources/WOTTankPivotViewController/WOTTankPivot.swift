//
//  WOTTankPivot.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTApi
import WOTKit
import WOTPivot

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

class WOTTankPivotModel: WOTPivotDataModel, RequestManagerListenerProtocol {
    public typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol

    private let appContext: Context
    let uuid: UUID = UUID()
    var MD5: String { uuid.MD5 }

    required init(modelListener: WOTDataModelListener, context: Context, settingsDatasource: WOTTankListSettingsDatasource) {
        appContext = context
        let fetchRequest = WOTTankPivotFetchRequest(datasource: settingsDatasource)
        let fetchController = WOTDataFetchController(nodeFetchRequestCreator: fetchRequest, context: context)

        let metadatasource = WOTTankPivotMetadatasource()
        let nodeCreator = WOTTankPivotNodeCreator()

        super.init(fetchController: fetchController,
                   modelListener: modelListener,
                   nodeCreator: nodeCreator,
                   metadatasource: metadatasource,
                   context: context)

        enumerator = WOTNodeEnumerator.sharedInstance
    }

    required init(enumerator _: WOTNodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    required init(fetchController _: WOTDataFetchControllerProtocol, modelListener _: WOTDataModelListener, nodeCreator _: WOTNodeCreatorProtocol, metadatasource _: WOTDataModelMetadatasource, context _: WOTPivotDataModel.Context) {
        fatalError("init(fetchController:modelListener:nodeCreator:metadatasource:context:) has not been implemented")
    }

    deinit {
        appContext.requestManager?.removeListener(self)
    }

    override var description: String { "\(type(of: self))" }

    override func loadModel() {
        super.loadModel()

        appContext.logInspector?.logEvent(EventFlowStart("Pivot"), sender: self)

        do {
            try WOTWEBRequestFactory.fetchVehiclePivotData(inContext: appContext, listener: self)
        } catch {
            appContext.logInspector?.logEvent(EventError(error, details: nil), sender: nil)
        }
    }

    override func cancelLoad(reason: RequestCancelReasonProtocol) {
        //
        appContext.requestManager?.cancelRequests(groupId: WebRequestType.vehicles.rawValue, reason: reason)
    }

    func requestManager(_ requestManager: RequestManagerProtocol, didParseDataForRequest _: RequestProtocol, completionResultType: WOTRequestManagerCompletionResultType) {
        if completionResultType == .finished || completionResultType == .noData {
            requestManager.removeListener(self)
            appContext.logInspector?.logEvent(EventFlowEnd("Pivot"), sender: self)
        }
        DispatchQueue.main.async {
            super.loadModel()
        }
    }

    func requestManager(_: RequestManagerProtocol, didStartRequest _: RequestProtocol) {
        //
    }

    func requestManager(_: RequestManagerProtocol, didCancelRequest _: RequestProtocol, reason _: RequestCancelReasonProtocol) {
        //
    }
}
