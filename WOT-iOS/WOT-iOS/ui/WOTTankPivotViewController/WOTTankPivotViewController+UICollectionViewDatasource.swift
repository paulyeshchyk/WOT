//
//  WOTTankPivotViewController+UICollectionViewDatasource.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/10/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: UICollectionViewDataSource {

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


extension WOTTankPivotViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let node = self.model.item(atIndexPath: indexPath as NSIndexPath)
        guard let pivotNode = node as? WOTPivotDataNode, let tank = pivotNode.data1 as? Tanks  else {
            return
        }
        let config = WOTTankModuleTreeViewController(nibName: String(describing:WOTTankModuleTreeViewController.self ), bundle: nil)
        config.tankId = tank.tank_id
        config.cancelBlock = {
            self.navigationController?.popViewController(animated: true)
        }
        config.doneBlock = { (conf) in
            self.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(config, animated: true)
    }
}
