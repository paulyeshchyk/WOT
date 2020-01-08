//
//  WOTTankPivotViewController.swift
//  WOT-iOS
//
//  Created on 8/10/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation
import WOTPivot

typealias WOTTankPivotCompletionCancelBlock = () -> Void
typealias WOTTankPivotCompletionDoneBlock = (_ configuration: Any) -> Void

@objc(WOTTankPivotViewController)

class WOTTankPivotViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var flowLayout: WOTTankPivotLayout?

    var cancelBlock: WOTTankPivotCompletionCancelBlock?
    var doneBlock: WOTTankPivotCompletionDoneBlock?
    lazy var refreshControl: WOTPivotRefreshControl = {
        return WOTPivotRefreshControl(target: self, action: #selector(WOTTankPivotViewController.refresh(_:)))
    }()

    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?

    lazy var model: WOTPivotDataModel = {
        let nodeCreator = WOTTankPivotNodeCreator()
        let fetchController = WOTDataTanksFetchController(nodeFetchRequestCreator: self)
        fetchController.nodeCreator = nodeCreator
        
        let enumerator = WOTNodeEnumerator.sharedInstance
        let metadatasource = WOTTankPivotMetadatasource()
        
        return WOTPivotDataModel(fetchController: fetchController,
                                 modelListener: self,
                                 nodeCreator: nodeCreator,
                                 metadatasource: metadatasource,
                                 enumerator: enumerator)
    }()

    override func viewDidLoad() {

        super.viewDidLoad()

        let items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(WOTTankPivotViewController.openConstructor(_:)))]
        self.navigationItem.setRightBarButtonItems(items, animated: false)


        self.collectionView?.bounces = true
        self.collectionView?.alwaysBounceHorizontal = false
        self.collectionView?.alwaysBounceVertical = false

        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl = self.refreshControl
        } else {
            self.collectionView?.addSubview(self.refreshControl)
        }

        self.navigationController?.navigationBar.setDarkStyle()

        self.setupFlow()

        self.registerCells()
        self.fullReload()
    }

    @objc
    func openConstructor(_ sender: Any) {

        let vc = WOTPivotConstructorViewController(nibName: "WOTPivotConstructorViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private func setupFlow() {

        self.flowLayout?.relativeContentSizeBlock = {
            return self.model.contentSize
        }
        self.flowLayout?.itemRelativeRectCallback = { (indexPath) in
            return self.model.itemRect(atIndexPath: indexPath  as NSIndexPath)
        }
        self.flowLayout?.itemLayoutStickyType = { (indexPath) in
            guard let node = self.model.item(atIndexPath: indexPath as NSIndexPath) else {
                return .float
            }
            return node.stickyType
        }
    }

    private func fullReload() {
        self.model.loadModel()
    }

    @objc
    func refresh(_ refreshControl: UIRefreshControl) {
        self.fullReload()
    }

}

extension WOTTankPivotViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.refreshControl.contentOffset = scrollView.contentOffset
    }
}

extension WOTTankPivotViewController: WOTDataModelListener {

    func modelDidLoad() {
        self.collectionView?.reloadData()
        self.refreshControl.endRefreshing()
    }

    func modelHasNewDataItem() {

    }

    func modelDidFailLoad(error: Error) {

        self.refreshControl.endRefreshing()
    }
}

extension WOTTankPivotViewController: WOTDataFetchControllerDelegateProtocol {

    var fetchRequest: NSFetchRequest<NSFetchRequestResult> {
        let result = NSFetchRequest<NSFetchRequestResult>(entityName: "Vehicles")
        result.sortDescriptors = self.sortDescriptors()
        result.predicate = self.fetchCustomPredicate()
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
