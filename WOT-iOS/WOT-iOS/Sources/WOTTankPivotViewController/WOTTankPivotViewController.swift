//
//  WOTTankPivotViewController.swift
//  WOT-iOS
//
//  Created on 8/10/18.
//  Copyright © 2018. All rights reserved.
//

import WOTPivot

// MARK: - PivotViewController

open class PivotViewController: UIViewController, ContextControllerProtocol {

    @IBOutlet open var collectionView: UICollectionView?

    override open var prefersStatusBarHidden: Bool { false }

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
                let node = self?.model.node(atIndexPath: indexPath) as? PivotNodeProtocol
                return node?.stickyType ?? .float()
            }
        }
    }

    public weak var appContext: ContextProtocol?

    lazy var refreshControl: WOTPivotRefreshControl = WOTPivotRefreshControl(target: self, action: #selector(WOTTankPivotViewController.refresh(_:)))

    var hasOpenedPopover: Bool = false

    override public init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)

        #warning("remove this")
        appContext = UIApplication.shared.delegate as? ContextProtocol
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        //
    }

    // MARK: Open

    private lazy var model: PivotDataModelProtocol = self.pivotModel()
    open func pivotModel() -> PivotDataModelProtocol {
        fatalError("has not been overriden")
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
        loadModel()
    }

    open func loadModel() {
        model.loadModel()
    }

    open func registerCells() {}

    // MARK: Internal

    func closePopover() {
        hasOpenedPopover = false
    }

    func openPopover() {
        hasOpenedPopover = true
    }
}

// MARK: - PivotViewController + UICollectionViewDataSource

extension PivotViewController: UICollectionViewDataSource {
    public func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let node = model.node(atIndexPath: indexPath) as? PivotNodeProtocol else {
            return UICollectionViewCell()
        }
        return cell(forNode: node, at: indexPath)
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.itemsCount(section: section)
    }
}

// MARK: - PivotViewController + UICollectionViewDelegate

extension PivotViewController: UICollectionViewDelegate {
    public func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let pivotNode = model.node(atIndexPath: indexPath) as? PivotNodeProtocol else {
            appContext?.logInspector?.log(.warning("cant find pivot node"), sender: self)
            return
        }

        guard hasOpenedPopover == false else {
            closePopover()
            return
        }

        let tankId = pivotNode.data1 as? NSDecimalNumber
        switch pivotNode.cellType {
        case .data: openTankDetail(tankId: tankId)
        case .dataGroup: openPopover()
        default: break
        }
    }

    private func openTankDetail(tankId: NSDecimalNumber?) {
        guard let tankId = tankId else {
            appContext?.logInspector?.log(.error(Errors.vehicleIsNotDefined), sender: self)
            return
        }
        let config = WOTTankModuleTreeViewController(nibName: String(describing: WOTTankModuleTreeViewController.self), bundle: nil)
        config.tank_Id = tankId
        config.cancelBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        config.doneBlock = { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationController?.pushViewController(config, animated: true)
    }
}

// MARK: - %t + PivotViewController.Errors

extension PivotViewController {
    enum Errors: Error {
        case vehicleIsNotDefined
    }
}

typealias WOTTankPivotCompletionCancelBlock = () -> Void
typealias WOTTankPivotCompletionDoneBlock = (_ configuration: Any) -> Void

// MARK: - WOTTankPivotViewController

@objc(WOTTankPivotViewController)
class WOTTankPivotViewController: PivotViewController {

    typealias Context = LogInspectorContainerProtocol
        & RequestRegistratorContainerProtocol
        & DecoderManagerContainerProtocol
        & DataStoreContainerProtocol
        & UOWManagerContainerProtocol

    static var registeredCells: [UICollectionViewCell.Type] = {
        return [WOTTankPivotDataCollectionViewCell.self,
                WOTTankPivotFilterCollectionViewCell.self,
                WOTTankPivotFixedCollectionViewCell.self,
                WOTTankPivotEmptyCollectionViewCell.self,
                WOTTankPivotDataGroupCollectionViewCell.self]
    }()

    var cancelBlock: WOTTankPivotCompletionCancelBlock?
    var doneBlock: WOTTankPivotCompletionDoneBlock?
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>?
    private let settingsDatasource = WOTTankListSettingsDatasource()

    private lazy var fetchRequest: WOTTankPivotFetchRequest = {
        let result = WOTTankPivotFetchRequest()
        result.settingsDatasource = settingsDatasource
        return result
    }()

    private lazy var fetchController: NodeFetchControllerProtocol = {
        let result = NodeFetchController(fetchRequestContainer: fetchRequest)
        return result
    }()

    private lazy var model: PivotDataModelProtocol = {
        let result = WOTTankPivotModel(modelListener: self, fetchController: self.fetchController)
        result.appContext = UIApplication.shared.delegate as? Context
        return result
    }()

    // MARK: Public

    @objc
    override public func registerCells() {
        WOTTankPivotViewController.registeredCells.forEach { (type) in
            let clazzStr = String(describing: type)
            let nib = UINib(nibName: clazzStr, bundle: nil)
            self.collectionView?.register(nib, forCellWithReuseIdentifier: clazzStr)
        }
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

    deinit {
        //
    }

    // MARK: Internal

    override func pivotModel() -> PivotDataModelProtocol {
        model
    }

    private var pivotTaskMD5: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPivotTaskProgress),
                                               name: NSNotification.Name.UOWProgress,
                                               object: nil)

        let items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(WOTTankPivotViewController.openConstructor(_:)))]
        navigationItem.setRightBarButtonItems(items, animated: false)

        fetchData()
    }

    func fetchData() {
        do {
            guard let appContext = UIApplication.shared.delegate as? WOTTankPivotViewController.Context else {
                throw WOTTankPivotViewControllerError.contextNotFound
            }

            pivotTaskMD5 = WOTWEBRequestFactory.fetchVehiclePivotData(appContext: appContext)

        } catch {
            appContext?.logInspector?.log(.error(error), sender: self)
        }
    }

    @objc
    func onPivotTaskProgress(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return
        }
        let wrapper = try? UOWStatusObjCWrapper(dictionary: userInfo)
        if wrapper?.subject == pivotTaskMD5 {
            print("pivot status: \(wrapper?.description ?? "")")
            if wrapper?.completed ?? false {
                DispatchQueue.main.async {
                    self.model.loadModel()
                }
            }
        }
    }

    @objc
    func openConstructor(_: Any) {
        let vc = WOTPivotConstructorViewController(nibName: "WOTPivotConstructorViewController", bundle: Bundle.main)
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func refresh(_: UIRefreshControl) {
        loadModel()
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
}

// MARK: - %t + WOTTankPivotViewController.WOTTankPivotViewControllerError

extension WOTTankPivotViewController {
    enum WOTTankPivotViewControllerError: Error {
        case contextNotFound
    }
}

extension WOTTankPivotViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        refreshControl.contentOffset = scrollView.contentOffset
    }
}

// MARK: - WOTTankPivotViewController + NodeDataModelListener

extension WOTTankPivotViewController: NodeDataModelListener {
    func didFinishLoadModel(error _: Error?) {
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
}
