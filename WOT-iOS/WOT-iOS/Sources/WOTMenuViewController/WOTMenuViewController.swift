//
//  WOTMenuViewControllerSwift.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

// MARK: - WOTMenuDelegate

@objc
protocol WOTMenuDelegate: NSObjectProtocol {
    var currentUserName: String { get }
    func menu(_ menu: WOTMenuProtocol, didSelectControllerClass controllerClass: AnyClass, title: String, image: UIImage)
    func loginPressedOnMenu(_ menu: WOTMenuProtocol)
}

// MARK: - WOTMenuProtocol

@objc
protocol WOTMenuProtocol: NSObjectProtocol {
    init(menuDatasource datasource: WOTMenuDatasource, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    var delegate: WOTMenuDelegate? { get set }
    var selectedMenuItemClass: AnyClass { get }
    var selectedMenuItemTitle: String { get }
    var selectedMenuItemImage: UIImage { get }
    func rebuildMenu()
}

// MARK: - WOTMenuViewController

@objc
class WOTMenuViewController: UIViewController, WOTMenuProtocol, WOTMenuDatasourceDelegate {

    var menuDatasource: WOTMenuDatasourceProtocol?

    @IBOutlet var tableView: UITableView?
    weak var delegate: WOTMenuDelegate?

    var selectedIndex: NSInteger = 0 {
        didSet {
            delegate?.menu(self, didSelectControllerClass: selectedMenuItemClass, title: selectedMenuItemTitle, image: selectedMenuItemImage)
        }
    }

    var selectedMenuItemClass: AnyClass {
        guard let item = menuDatasource?.object(at: selectedIndex) else {
            return DefaultMenuViewController.self
        }
        return item.controllerClass
    }

    var selectedMenuItemTitle: String {
        let item = menuDatasource?.object(at: selectedIndex)
        return item?.controllerTitle ?? ""
    }

    var selectedMenuItemImage: UIImage {
        let item = menuDatasource?.object(at: selectedIndex)
        return item?.icon ?? UIImage()
    }

    // MARK: Lifecycle

    required convenience init(menuDatasource datasource: WOTMenuDatasource, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        menuDatasource = datasource
        menuDatasource?.delegate = self
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    func rebuildMenu() {
        menuDatasource?.rebuild()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tableView.backgroundColor = WOT_COLOR_DARK_VIEW_BACKGROUND;
        //        self.view.backgroundColor = WOT_COLOR_DARK_VIEW_BACKGROUND;

        let nib = UINib(nibName: String(describing: WOTMenuTableViewCell.self), bundle: nil)
        tableView?.register(nib, forCellReuseIdentifier: String(describing: WOTMenuTableViewCell.self))

        redrawNavigationBar()
    }

    @objc func loginPressed(_: AnyObject?) {
        delegate?.loginPressedOnMenu(self)
    }

    // MARK: - WOTMenuDatasourceDelegate

    func hasUpdatedData(_: WOTMenuDatasourceProtocol) {
        redrawNavigationBar()
        selectedIndex = 0
        tableView?.reloadData()
    }

    // MARK: Fileprivate

    fileprivate func redrawNavigationBar() {
        navigationController?.navigationBar.setDarkStyle()
        let image = UIImage(named: WOTApi.L10n.wotImageUser)
        let backButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.done, target: self, action: #selector(WOTMenuViewController.loginPressed(_:)))
        navigationItem.leftBarButtonItems = [backButton]
        navigationItem.title = delegate?.currentUserName
    }
}

// MARK: - WOTMenuViewController + UITableViewDataSource, UITableViewDelegate

extension WOTMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return menuDatasource?.objectsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let result = tableView.dequeueReusableCell(withIdentifier: String(describing: WOTMenuTableViewCell.self), for: indexPath) as? WOTMenuTableViewCell else {
            return UITableViewCell()
        }
        if let menuItem = menuDatasource?.object(at: indexPath.row) {
            result.cellTitle = menuItem.controllerTitle
            result.cellImage = menuItem.icon
        }
        return result
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedIndex = indexPath.row
    }
}

// MARK: - DefaultMenuViewController

class DefaultMenuViewController: UIViewController, ContextControllerProtocol {
    var appContext: ContextProtocol?
}
