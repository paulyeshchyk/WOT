//
//  SteelPivotViewController.swift
//  WOTPivotSamples
//
//  Created by Pavel Yeshchyk on 6/5/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import UIKit
import WOTPivot
import CoreData

class SteelPivotViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?
    lazy var model: WOTPivotDataModel = {
        return WOTPivotDataModel(fetchController: self.fetchController, modelListener: self, nodeCreator: self, enumerator: WOTNodeEnumerator.sharedInstance)
    }()
    
    lazy var fetchController: WOTDataFetchControllerProtocol = {
        //return SteelPivotFetchController(nodeFetchRequestCreator: self, nodeCreator: self)
        return SteelPivotFetchController()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model.loadModel()
    }
}

class SteelPivotFetchController: WOTDataFetchControllerProtocol {
    var listener: WOTDataFetchControllerListenerProtocol?

    func performFetch() throws {
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
    func modelDidLoad() {
        self.collectionView?.reloadData()
    }
    
    func modelDidFailLoad(error: Error) {
        self.collectionView?.reloadData()
    }
    
    func metadataItems() -> [WOTNodeProtocol] {
        return []
    }
    
    func modelHasNewDataItem() {
    }
}

extension SteelPivotViewController: WOTDataFetchControllerDelegateProtocol {
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "test")
    }
}

extension SteelPivotViewController: WOTNodeCreatorProtocol {
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


extension SteelPivotViewController: UICollectionViewDelegate {
    
}

extension SteelPivotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SteelCollectionViewCell", for: indexPath)
    }
    
    
}
