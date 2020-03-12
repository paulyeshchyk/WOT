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

#warning ("TO BE REFACTORED")
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

    func filters () -> [WOTNodeProtocol] {
        return [WOTPivotFilterNode(name: "Filter")]
    }
}

class WOTTankPivotModel: WOTPivotDataModel {

    convenience init(modelListener: WOTDataModelListener) {
        
        let fetchRequest = WOTTankPivotFetchRequest()
        let dataProvider = WOTTankCoreDataProvider.sharedInstance
        let fetchController = WOTDataFetchController(nodeFetchRequestCreator: fetchRequest, dataprovider: dataProvider)
        
        let metadatasource = WOTTankPivotMetadatasource()
        let nodeCreator = WOTTankPivotNodeCreator()

        self.init(fetchController: fetchController,
                  modelListener: modelListener,
                  nodeCreator: nodeCreator,
                  metadatasource: metadatasource)
        
        self.enumerator = WOTNodeEnumerator.sharedInstance

        let notificationName = NSNotification.Name(rawValue: WOTRequestManager.pendingRequestNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(pendingRequestCountChaged(notification:)), name: notificationName, object: nil)
    }
    
    deinit {
        let notificationName = NSNotification.Name(rawValue: WOTRequestManager.pendingRequestNotificationName)
        NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
    }
    
    override func loadModel() {
        super.loadModel()
        
        performWebRequest()
    }
    
    
    @objc private func pendingRequestCountChaged(notification: NSNotification) {
        guard let executor = notification.object as? WOTRequestManager else {
            return
        }
        guard executor.pendingRequestsCount == 0 else {
            return
        }
        
        super.loadModel()
    }

    private let nestedRequestsEvaluator: WOTNestedRequestsEvaluatorProtocol = WOTNestedRequestEvaluator()
    
    private func performWebRequest() {
        let appManager = (UIApplication.shared.delegate as? WOTAppDelegateProtocol)?.appManager
        let requestManager = appManager?.requestManager
        
        if let hostConfiguration = appManager?.hostConfiguration {

            let arguments = WOTRequestArguments()
            arguments.setValues(Vehicles.keypathsLight(), forKey: WGWebQueryArgs.fields)
            
            if let request = requestManager?.requestReception.createRequest(forRequestId: WOTRequestId.tankVehicles.rawValue) {
                request.hostConfiguration = hostConfiguration
                requestManager?.start(request, with: arguments, forGroupId: WGWebRequestGroups.vehicle_list)
            }
        }
    }
}

@objc
public class WOTNestedRequestEvaluator: NSObject {

    fileprivate var hostConfiguration: WOTHostConfigurationProtocol? {
        let appManager = (UIApplication.shared.delegate as? WOTAppDelegateProtocol)?.appManager
        return appManager?.hostConfiguration
    }
    
    fileprivate var requestManager: WOTRequestManagerProtocol? {
        let appManager = (UIApplication.shared.delegate as? WOTAppDelegateProtocol)?.appManager
        return appManager?.requestManager
    }
}

extension WOTNestedRequestEvaluator: WOTNestedRequestsEvaluatorProtocol {

    @discardableResult
    private func queueRequest(for requestId: WOTRequestIdType, nestedRequest: JSONLinkedObjectRequest) -> Bool {

        guard let requestManager = self.requestManager else { return false }
        guard let clazz = nestedRequest.clazz as? NSObject.Type, clazz.conforms(to: KeypathProtocol.self) else { return false }
        guard let obj = clazz.init() as? KeypathProtocol else { return false }
        guard let request = requestManager.requestReception.createRequest(forRequestId: requestId) else { return false }

        let keyPaths = obj.instanceKeypaths()

        let arguments = WOTRequestArguments()
        #warning("forKey: fields should be refactored")
        arguments.setValues(keyPaths, forKey: "fields")
        if let ident = nestedRequest.identifier, let ident_fieldName = nestedRequest.identifier_fieldname {
            arguments.setValues([ident], forKey: ident_fieldName)
        }

        request.hostConfiguration = hostConfiguration

        let groupId = "Nested\(String(describing: clazz))-\(nestedRequest.identifier ?? "")"

        return requestManager.start(request, with: arguments, forGroupId: groupId)
    }
    
    public func evaluate(nestedRequests: [JSONLinkedObjectRequest]?) {
        
        DispatchQueue.main.async { [weak self] in

            guard let requestManager = self?.requestManager else {
                return
            }

            nestedRequests?.forEach( { nestedRequest in
                let requestIDs = requestManager.requestReception.requestIds(forClass: nestedRequest.clazz)
                requestIDs?.forEach({ (requestId) in
                    self?.queueRequest(for: requestId, nestedRequest: nestedRequest)
                })
            })
        }
    }
}

