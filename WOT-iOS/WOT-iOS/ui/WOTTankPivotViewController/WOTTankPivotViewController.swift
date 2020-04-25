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

open class WOTPivotViewController: UIViewController {
    @IBOutlet open var collectionView: UICollectionView?

    @IBOutlet open var flowLayout: WOTPivotLayout? {
        didSet {
            flowLayout?.relativeContentSizeBlock = { [weak self] in
                let size = self?.model.contentSize
                return size ?? CGSize.zero
            }
            flowLayout?.itemRelativeRectCallback = { [weak self] (indexPath) in
                let itemRect = self?.model.itemRect(atIndexPath: indexPath  as NSIndexPath)
                return itemRect ?? CGRect.zero
            }
            flowLayout?.itemLayoutStickyType = { [weak self] (indexPath) in
                let node = self?.model.item(atIndexPath: indexPath as NSIndexPath)
                return node?.stickyType ?? .float
            }
        }
    }

    lazy var refreshControl: WOTPivotRefreshControl = {
        return WOTPivotRefreshControl(target: self, action: #selector(WOTTankPivotViewController.refresh(_:)))
    }()

    open func pivotModel() -> WOTPivotDataModelProtocol {
        return WOTPivotDataModel(enumerator: WOTNodeEnumerator.sharedInstance)
    }

    lazy var model: WOTPivotDataModelProtocol  = {
        return pivotModel()
    }()

    static var openedPopoverKey: UInt8 = 0
    var hasOpenedPopover: Bool {
        get {
            guard let result = objc_getAssociatedObject(self, &WOTTankPivotViewController.openedPopoverKey) as? Bool else {
                return false
            }
            return result
        }
        set {
            objc_setAssociatedObject(self, &WOTTankPivotViewController.openedPopoverKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    func closePopover() {
        self.hasOpenedPopover = false
    }

    func openPopover() {
        self.hasOpenedPopover = true
    }

    open func cell(forDataNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func cell(forNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        switch node.cellType {
        case .column, .row: return self.cell(forFixedNode: node, at: indexPath)
        case .filter:       return self.cell(forFilterNode: node, at: indexPath)
        case .data:         return self.cell(forDataNode: node, at: indexPath)
        case .dataGroup:    return self.cell(forDataGroupNode: node, at: indexPath)
        }
    }

    open func cell(forFixedNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open  func cell(forFilterNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func cell(forDataGroupNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    override open func viewDidLoad() {
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

        self.registerCells()
        self.model.loadModel()
    }

    open func registerCells() {}
}

extension WOTPivotViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let node = self.model.item(atIndexPath: indexPath as NSIndexPath) else {
            return UICollectionViewCell()
        }
        return self.cell(forNode: node, at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.itemsCount(section: section)
    }
}

extension WOTPivotViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pivotNode = self.model.item(atIndexPath: indexPath as NSIndexPath)  else {
            return
        }

        guard self.hasOpenedPopover == false else {
            self.closePopover()
            return
        }

        let fetchedObject = pivotNode.data1 as? NSManagedObject
        switch pivotNode.cellType {
        case .data: openTankDetail(data: fetchedObject)
        case .dataGroup: openPopover()
        default: break
        }
    }

    private func openTankDetail(data: NSManagedObject?) {
        guard let vehicle = data as? Vehicles else {
            return
        }
        let config = WOTTankModuleTreeViewController(nibName: String(describing: WOTTankModuleTreeViewController.self), bundle: nil)
        config.tank_Id = vehicle.tank_id
        config.cancelBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        config.doneBlock = { (conf) in
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(config, animated: true)
    }
}

@objc(WOTTankPivotViewController)
class WOTTankPivotViewController: WOTPivotViewController {
    var cancelBlock: WOTTankPivotCompletionCancelBlock?
    var doneBlock: WOTTankPivotCompletionDoneBlock?
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?

    override func pivotModel() -> WOTPivotDataModelProtocol {
        return WOTTankPivotModel(modelListener: self, dataProvider: WOTPivotAppManager.sharedInstance.coreDataProvider)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(WOTTankPivotViewController.openConstructor(_:)))]
        self.navigationItem.setRightBarButtonItems(items, animated: false)
    }

    @objc
    func openConstructor(_ sender: Any) {
        let vc = WOTPivotConstructorViewController(nibName: "WOTPivotConstructorViewController", bundle: Bundle.main)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func refresh(_ refreshControl: UIRefreshControl) {
        self.model.loadModel()
    }

    static var registeredCells: [UICollectionViewCell.Type] = {
        return [WOTTankPivotDataCollectionViewCell.self,
                WOTTankPivotFilterCollectionViewCell.self,
                WOTTankPivotFixedCollectionViewCell.self,
                WOTTankPivotEmptyCollectionViewCell.self,
                WOTTankPivotDataGroupCollectionViewCell.self]
    }()

    @objc
    override public func registerCells() {
        WOTTankPivotViewController.registeredCells.forEach { (type) in
            let clazzStr = String(describing: type)
            let nib = UINib(nibName: clazzStr, bundle: nil)
            self.collectionView?.register(nib, forCellWithReuseIdentifier: clazzStr)
        }
    }

    override func cell(forDataNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotDataCollectionViewCell.self)
        guard let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotDataCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.symbol = node.name
        cell.dataViewColor = node.dataColor
        cell.uuid = node.index
        return cell
    }

    override func cell(forDataGroupNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotDataGroupCollectionViewCell.self)
        guard let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotDataGroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }

    override public func cell(forFixedNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFixedCollectionViewCell.self)
        guard let result = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as?  WOTTankPivotFixedCollectionViewCell else {
            return UICollectionViewCell()
        }
        result.textValue = node.name
        return result
    }

    override public func cell(forFilterNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFilterCollectionViewCell.self)
        guard let result = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) else {
            return UICollectionViewCell()
        }
        return result
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

    func modelDidFailLoad(error: Error) {
        self.refreshControl.endRefreshing()
    }
}
