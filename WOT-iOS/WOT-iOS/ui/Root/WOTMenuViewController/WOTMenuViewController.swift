//
//  WOTMenuViewControllerSwift.swift
//  WOT-iOS
//
//  Created on 8/14/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
protocol WOTMenuDelegate: NSObjectProtocol {
    var currentUserName: String { get }
    func menu(_ menu: WOTMenuProtocol, didSelectControllerClass controllerClass: AnyClass, title: String, image: UIImage)
    func loginPressedOnMenu(_ menu: WOTMenuProtocol)

}

@objc
protocol WOTMenuProtocol: NSObjectProtocol {
    var delegate: WOTMenuDelegate? { get set }
    var selectedMenuItemClass: AnyClass { get }
    var selectedMenuItemTitle: String { get }
    var selectedMenuItemImage: UIImage { get }
}

@objc(WOTMenuViewController)

class WOTMenuViewController: UIViewController, WOTMenuProtocol {

    @IBOutlet var tableView: UITableView?
    var selectedIndex: NSInteger = 0 {
        didSet {
            self.delegate?.menu(self, didSelectControllerClass: self.selectedMenuItemClass, title: self.selectedMenuItemTitle, image: self.selectedMenuItemImage)
        }
    }
    var menuDatasource: WOTMenuDatasourceProtocol?

    weak var delegate: WOTMenuDelegate?
    var selectedMenuItemClass: AnyClass {
        let item = self.menuDatasource?.object(at: self.selectedIndex)
        return item?.controllerClass ?? WOTMenuViewController.self
    }

    var selectedMenuItemTitle: String {
        let item = self.menuDatasource?.object(at: self.selectedIndex)
        return item?.controllerTitle ?? ""
    }

    var selectedMenuItemImage: UIImage {
        let item = self.menuDatasource?.object(at: self.selectedIndex)
        return item?.icon ?? UIImage()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.menuDatasource = WOTMenuDatasource()
        self.menuDatasource?.delegate = self
        self.menuDatasource?.rebuild()
        self.selectedIndex = 0

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tableView.backgroundColor = WOT_COLOR_DARK_VIEW_BACKGROUND;
        //        self.view.backgroundColor = WOT_COLOR_DARK_VIEW_BACKGROUND;

        let nib = UINib(nibName: String(describing: WOTMenuTableViewCell.self), bundle: nil)
        self.tableView?.register(nib, forCellReuseIdentifier: String(describing: WOTMenuTableViewCell.self))

        self.redrawNavigationBar()

    }

    fileprivate func redrawNavigationBar() {
        self.navigationController?.navigationBar .setDarkStyle()
        let image = UIImage(named: L10n.wotImageUser)
        let backButton = UIBarButtonItem(image: image, style: UIBarButtonItem.Style.done, target: self, action: #selector(WOTMenuViewController.loginPressed(_ :)))
        self.navigationItem.leftBarButtonItems = [backButton]
        self.navigationItem.title = self.delegate?.currentUserName
    }

    @objc func loginPressed(_ obj: AnyObject?) {
        self.delegate?.loginPressedOnMenu(self)
    }
}

extension WOTMenuViewController: WOTMenuDatasourceDelegate {
    func hasUpdatedData(_ datasource: WOTMenuDatasourceProtocol) {
        self.redrawNavigationBar()
        self.selectedIndex = 0
        self.tableView?.reloadData()
    }
}

extension WOTMenuViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuDatasource?.objectsCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let result = tableView.dequeueReusableCell(withIdentifier: String(describing: WOTMenuTableViewCell.self), for: indexPath) as? WOTMenuTableViewCell else {
            return UITableViewCell()
        }
        if let menuItem = self.menuDatasource?.object(at: indexPath.row) {
            result.cellTitle = menuItem.controllerTitle
            result.cellImage = menuItem.icon
        }
        return result
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.selectedIndex = indexPath.row
    }

}
