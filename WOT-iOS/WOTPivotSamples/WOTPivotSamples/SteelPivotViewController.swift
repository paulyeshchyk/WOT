//
//  SteelPivotViewController.swift
//  WOTPivotSamples
//
//  Created by Pavel Yeshchyk on 6/5/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import UIKit
import WOTPivot
import WOTApi
import CoreData

class SteelPivotViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView?
    lazy var model: WOTPivotDataModel = {
        return WOTPivotDataModel(fetchController: self.fetchController, modelListener: self, nodeCreator: self, metadatasource: self.metadatasource)
    }()

    lazy var fetchController: WOTDataFetchControllerProtocol = {
        // return SteelPivotFetchController(nodeFetchRequestCreator: self, nodeCreator: self)
        return SteelPivotFetchController()
    }()

    let metadatasource = WOTTankPivotMetadatasource()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model.loadModel()
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

class SteelPivotFetchController: WOTDataFetchControllerProtocol {
    func fetchedNodes(byPredicates: [NSPredicate], nodeCreator: WOTNodeCreatorProtocol?, filteredCompletion: (NSPredicate, [AnyObject]?) -> Void) {}

    var listener: WOTDataFetchControllerListenerProtocol?

    func performFetch(nodeCreator: WOTNodeCreatorProtocol?) throws {
        self.listener?.fetchPerformed(by: self)
    }

    func fetchedNodes(byPredicates: [NSPredicate]) -> [WOTNodeProtocol] {
        print(byPredicates)
        return []
    }

    func fetchedObjects() -> [AnyObject]? {
        return nil
    }

    func setFetchListener(_ listener: WOTDataFetchControllerListenerProtocol?) {
        self.listener = listener
    }
}

extension SteelPivotViewController: WOTDataModelListener {
    func didFinishLoadModel(error: Error?) {
        self.collectionView?.reloadData()
    }

    func metadataItems() -> [WOTNodeProtocol] {
        return []
    }
}

extension SteelPivotViewController: WOTDataFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "test")
    }
}

extension SteelPivotViewController: WOTNodeCreatorProtocol {
    func createNodeGroup(name: String, fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol {
        let result = WOTPivotDataGroupNode(name: name)
        result.fetchedObjects = fetchedObjects
        return result
    }

    func createNode(fetchedObject: AnyObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {
        return WOTPivotDataNode(name: "noname")
    }

    var collapseToGroups: Bool {
        return false
    }

    var useEmptyNode: Bool {
        return true
    }

    func createEmptyNode() -> WOTNodeProtocol {
        return WOTNode(name: "Test")
    }

    func createNode(name: String) -> WOTNodeProtocol {
        return WOTNode(name: name)
    }

    func createNode(fetchedObject: NSManagedObject?, byPredicate: NSPredicate?) -> WOTNodeProtocol {
        return WOTNode(name: "Test")
    }

    func createNodes(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> [WOTNodeProtocol] {
        return [WOTNode(name: "Test")]
    }

    func createNodeGroup(fetchedObjects: [AnyObject], byPredicate: NSPredicate?) -> WOTNodeProtocol {
        return WOTNode(name: "Test")
    }
}

extension SteelPivotViewController: UICollectionViewDelegate {}

extension SteelPivotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SteelCollectionViewCell", for: indexPath)
    }
}
