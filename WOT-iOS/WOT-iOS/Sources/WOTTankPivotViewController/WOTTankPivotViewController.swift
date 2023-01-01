//
//  WOTTankPivotViewController.swift
//  WOT-iOS
//
//  Created on 8/10/18.
//  Copyright © 2018. All rights reserved.
//

import WOTKit
import WOTPivot

open class PivotViewController: UIViewController, ContextControllerProtocol {
    public var appContext: ContextProtocol?
    @IBOutlet open var collectionView: UICollectionView?

    @IBOutlet open var flowLayout: WGPivotColoredFlowLayout? {
        didSet {
            flowLayout?.relativeContentSizeBlock = { [weak self] in
                let size = self?.model.contentSize
                return size ?? CGSize.zero
            }
            flowLayout?.itemRelativeRectCallback = { [weak self] (indexPath) in
                let itemRect = self?.model.itemRect(atIndexPath: indexPath)
                return itemRect ?? CGRect.zero
            }
            flowLayout?.itemLayoutStickyType = { [weak self] (indexPath) in
                let node = self?.model.item(atIndexPath: indexPath)
                return node?.stickyType ?? .float
            }
        }
    }

    lazy var refreshControl: WOTPivotRefreshControl = {
        return WOTPivotRefreshControl(target: self, action: #selector(WOTTankPivotViewController.refresh(_:)))
    }()

    open func pivotModel() -> PivotDataModelProtocol {
        return PivotDataModel(enumerator: NodeEnumerator.sharedInstance)
    }

    lazy var model: PivotDataModelProtocol = {
        return pivotModel()
    }()

    var hasOpenedPopover: Bool = false

    func closePopover() {
        hasOpenedPopover = false
    }

    func openPopover() {
        hasOpenedPopover = true
    }

    open func cell(forDataNode _: PivotNodeProtocol, at _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func cell(forNode node: PivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        switch node.cellType {
        case .column,
             .row: return cell(forFixedNode: node, at: indexPath)
        case .filter: return cell(forFilterNode: node, at: indexPath)
        case .data: return cell(forDataNode: node, at: indexPath)
        case .dataGroup: return cell(forDataGroupNode: node, at: indexPath)
        }
    }

    open func cell(forFixedNode _: PivotNodeProtocol, at _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func cell(forFilterNode _: PivotNodeProtocol, at _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    open func cell(forDataGroupNode _: PivotNodeProtocol, at _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.bounces = true
        collectionView?.alwaysBounceHorizontal = false
        collectionView?.alwaysBounceVertical = false

        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl = self.refreshControl
        } else {
            collectionView?.addSubview(refreshControl)
        }

        navigationController?.navigationBar.setDarkStyle()

        registerCells()
        model.loadModel()
    }

    open func registerCells() {}
}

extension PivotViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let node = model.item(atIndexPath: indexPath) else {
            return UICollectionViewCell()
        }
        return cell(forNode: node, at: indexPath)
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.itemsCount(section: section)
    }
}

extension PivotViewController: UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pivotNode = model.item(atIndexPath: indexPath) else {
            return
        }

        guard hasOpenedPopover == false else {
            closePopover()
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
        config.cancelBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        config.doneBlock = { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(config, animated: true)
    }
}

typealias WOTTankPivotCompletionCancelBlock = () -> Void
typealias WOTTankPivotCompletionDoneBlock = (_ configuration: Any) -> Void

@objc(WOTTankPivotViewController)
class WOTTankPivotViewController: PivotViewController {
    typealias Context = LogInspectorContainerProtocol & DataStoreContainerProtocol & RequestManagerContainerProtocol & DataStoreContainerProtocol
    var cancelBlock: WOTTankPivotCompletionCancelBlock?
    var doneBlock: WOTTankPivotCompletionDoneBlock?
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    var settingsDatasource = WOTTankListSettingsDatasource()

    override func pivotModel() -> PivotDataModelProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? Context else {
            fatalError("appDelegate is not WOTAppDelegateProtocol")
        }
        return WOTTankPivotModel(modelListener: self, context: appDelegate, settingsDatasource: settingsDatasource)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(WOTTankPivotViewController.openConstructor(_:)))]
        navigationItem.setRightBarButtonItems(items, animated: false)
    }

    @objc
    func openConstructor(_: Any) {
        let vc = WOTPivotConstructorViewController(nibName: "WOTPivotConstructorViewController", bundle: Bundle.main)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func refresh(_: UIRefreshControl) {
        model.loadModel()
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

    override func cell(forDataNode node: PivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotDataCollectionViewCell.self)
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotDataCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.symbol = node.name
        cell.dataViewColor = node.dataColor
        cell.uuid = node.index
        return cell
    }

    override func cell(forDataGroupNode _: PivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotDataGroupCollectionViewCell.self)
        guard let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotDataGroupCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }

    override public func cell(forFixedNode node: PivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFixedCollectionViewCell.self)
        guard let result = collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotFixedCollectionViewCell else {
            return UICollectionViewCell()
        }
        result.textValue = node.name
        return result
    }

    override public func cell(forFilterNode _: PivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFilterCollectionViewCell.self)
        guard let result = collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) else {
            return UICollectionViewCell()
        }
        return result
    }
}

extension WOTTankPivotViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.contentOffset = scrollView.contentOffset
    }
}

extension WOTTankPivotViewController: NodeDataModelListener {
    func didFinishLoadModel(error _: Error?) {
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
}
