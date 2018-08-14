//
//  WOTTankPivotViewController.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/10/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

typealias WOTTankPivotCompletionCancelBlock = () -> ()
typealias WOTTankPivotCompletionDoneBlock = (_ configuration: Any) -> ()

@objc(WOTTankPivotViewController)

class WOTTankPivotViewController : UIViewController {
    
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var flowLayout: WOTTankPivotLayout?

    var cancelBlock: WOTTankPivotCompletionCancelBlock?
    var doneBlock: WOTTankPivotCompletionDoneBlock?
    lazy var refreshControl: WOTPivotRefreshControl = {
        return WOTPivotRefreshControl(target: self, action: #selector(WOTTankPivotViewController.refresh(_:)))
    }()

    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?

    lazy var fetchController: WOTDataFetchControllerProtocol = {
        return WOTDataTanksFetchController(nodeFetchRequestCreator: self, nodeCreator: self)
    }()

    lazy var model: WOTPivotDataModel = {
        return WOTPivotDataModel(fetchController: self.fetchController, modelListener: self, nodeCreator: self)
    }()

    override func viewDidLoad() {

        super.viewDidLoad()

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

    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.fullReload()
    }

}

extension WOTTankPivotViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.refreshControl.contentOffset = scrollView.contentOffset
    }
}
