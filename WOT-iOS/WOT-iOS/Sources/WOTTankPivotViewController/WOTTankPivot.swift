//
//  WOTTankPivot.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 1/9/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import ContextSDK
import WOTApi
import WOTPivot

// MARK: - WOTTankPivotNodeCreator

class WOTTankPivotNodeCreator: PivotNodeCreator {
    #warning("Pivot configuration: collapse")
    override public var collapseToGroups: Bool { return true }

    override public var useEmptyNode: Bool { return false }

    // MARK: Public

    override public func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> NodeProtocol {
        let name = (fetchedObject as? Vehicles)?.name ?? ""
        let type = (fetchedObject as? Vehicles)?.type ?? ""
        guard let tankId = (fetchedObject as? Vehicles)?.tank_id?.decimalValue else {
            fatalError("tankid is not defined")
        }
        let color = WOTNodeFactory.typeColors()[type] as? UIColor
        let result = DataPivotNode(name: name)
        result.predicate = byPredicate
        #warning("Direct access to ManagedObject property (tank_id)")
        result.data1 = NSDecimalNumber(decimal: tankId)
        result.dataColor = color
        return result
    }
}

// MARK: - WOTTankPivotFetchRequest

class WOTTankPivotFetchRequest: FetchRequestContainerProtocol {

    weak var settingsDatasource: WOTTankListSettingsDatasource?

    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehicles")
        result.sortDescriptors = sortDescriptors()
        result.predicate = fetchCustomPredicate()
        return result
    }

    // MARK: Private

    private func sortDescriptors() -> [NSSortDescriptor] {
        let tankIdDescriptor = NSSortDescriptor(key: "tank_id", ascending: true)
        var result: [NSSortDescriptor] = []
        if let sortBy = settingsDatasource?.sortBy {
            result.append(contentsOf: sortBy)
        }
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

// MARK: - WOTTankPivotMetadatasource

class WOTTankPivotMetadatasource: PivotMetaDatasourceProtocol {

    private let permutator = PivotMetadataPermutator()

    // MARK: Internal

    func metadataItems() -> [NodeProtocol] {
        var result = [NodeProtocol]()

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

    func filters() -> [NodeProtocol] {
        return [FilterPivotNode(name: "Filter")]
    }
}

// MARK: - WOTTankPivotModel

class WOTTankPivotModel: PivotDataModel {

    var MD5: String { uuid.MD5 }

    override var description: String { "\(type(of: self))" }

    private let uuid = UUID()
    private let metadatasource = WOTTankPivotMetadatasource()
    private let customNodeCreator = WOTTankPivotNodeCreator()

    // MARK: Lifecycle

    required init(modelListener: NodeDataModelListener, fetchController: NodeFetchControllerProtocol, appContext: Context) {
        super.init(fetchController: fetchController,
                   modelListener: modelListener,
                   nodeCreator: customNodeCreator,
                   metadatasource: metadatasource,
                   nodeIndex: NodeIndex.self,
                   appContext: appContext)
    }

    required init(enumerator _: NodeEnumeratorProtocol) {
        fatalError("init(enumerator:) has not been implemented")
    }

    required init(fetchController _: NodeFetchControllerProtocol, modelListener _: NodeDataModelListener, nodeCreator _: NodeCreatorProtocol, metadatasource _: PivotMetaDatasourceProtocol, context _: Context) {
        fatalError("init(fetchController:modelListener:nodeCreator:metadatasource:context:) has not been implemented")
    }

    @objc required init(fetchController _: NodeFetchControllerProtocol, modelListener _: NodeDataModelListener, nodeCreator _: NodeCreatorProtocol, metadatasource _: PivotMetaDatasourceProtocol, nodeIndex _: NodeIndexProtocol.Type, appContext _: Context) {
        fatalError("init(fetchController:modelListener:nodeCreator:metadatasource:nodeIndex:context:) has not been implemented")
    }

    required init(nodeIndex _: NodeIndexProtocol.Type, appContext _: Context) {
        fatalError("init(nodeIndex:) has not been implemented")
    }

    deinit {
        //
    }

    // MARK: Internal

    override func loadModel() {
        super.loadModel()

        do {
            try WOTWEBRequestFactory.fetchVehiclePivotData(appContext: appContext) { result in
                if let error = result.error {
                    self.appContext.logInspector?.log(.warning(error: error), sender: self)
                }
                DispatchQueue.main.async {
                    super.loadModel()
                }
            }
        } catch {
            appContext.logInspector?.log(.error(error), sender: self)
        }
    }
}
