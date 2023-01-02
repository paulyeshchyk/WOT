//
//  SteelPivotViewController.swift
//  WOTPivotSamples
//
//  Created by Pavel Yeshchyk on 6/5/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import CoreData
import UIKit
import WOTApi
import WOTPivot

class SteelPivotViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView?
    lazy var model: PivotDataModel = {
        return PivotDataModel(fetchController: self.fetchController, modelListener: self, nodeCreator: self, metadatasource: self.metadatasource)
    }()

    lazy var fetchController: WOTDataFetchControllerProtocol = {
        // return SteelPivotFetchController(nodeFetchRequestCreator: self, nodeCreator: self)
        return SteelPivotFetchController()
    }()

    let metadatasource = WOTTankPivotMetadatasource()
    override func viewDidLoad() {
        super.viewDidLoad()

        model.loadModel()
    }
}

class WOTTankPivotMetadatasource: WOTDataModelMetadatasource {
    private let permutator = PivotMetadataPermutator()

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

class SteelPivotFetchController: WOTDataFetchControllerProtocol {
    func fetchedNodes(byPredicates _: [NSPredicate], nodeCreator _: NodeCreatorProtocol?, filteredCompletion _: (NSPredicate, [AnyObject]?) -> Void) {}

    var listener: WOTDataFetchControllerListenerProtocol?

    func performFetch(nodeCreator _: NodeCreatorProtocol?) throws {
        listener?.fetchPerformed(by: self)
    }

    func fetchedNodes(byPredicates: [NSPredicate]) -> [NodeProtocol] {
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

extension SteelPivotViewController: DataModelListener {
    func didFinishLoadModel(error _: Error?) {
        collectionView?.reloadData()
    }

    func metadataItems() -> [NodeProtocol] {
        return []
    }
}

extension SteelPivotViewController: FetchRequestContainerProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "test")
    }
}

extension SteelPivotViewController: NodeCreatorProtocol {
    func createNodeGroup(name: String, fetchedObjects: [AnyObject], byPredicate _: NSPredicate?) -> NodeProtocol {
        let result = DataGroupPivotNode(name: name)
        result.fetchedObjects = fetchedObjects
        return result
    }

    func createNode(fetchedObject _: AnyObject?, byPredicate _: NSPredicate?) -> NodeProtocol {
        return DataPivotNode(name: "noname")
    }

    var collapseToGroups: Bool {
        return false
    }

    var useEmptyNode: Bool {
        return true
    }

    func createEmptyNode() -> NodeProtocol {
        return Node(name: "Test")
    }

    func createNode(name: String) -> NodeProtocol {
        return Node(name: name)
    }

    func createNode(fetchedObject _: NSManagedObject?, byPredicate _: NSPredicate?) -> NodeProtocol {
        return Node(name: "Test")
    }

    func createNodes(fetchedObjects _: [AnyObject], byPredicate _: NSPredicate?) -> [NodeProtocol] {
        return [Node(name: "Test")]
    }

    func createNodeGroup(fetchedObjects _: [AnyObject], byPredicate _: NSPredicate?) -> NodeProtocol {
        return Node(name: "Test")
    }
}

extension SteelPivotViewController: UICollectionViewDelegate {}

extension SteelPivotViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SteelCollectionViewCell", for: indexPath)
    }
}
