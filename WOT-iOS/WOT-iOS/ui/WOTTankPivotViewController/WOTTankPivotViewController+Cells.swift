//
//  WOTTankPivotViewController+Cells.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/10/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation


extension WOTTankPivotViewController {
    static var registeredCells: [UICollectionViewCell.Type] = {
        return [WOTTankPivotDataCollectionViewCell.self,
                WOTTankPivotFilterCollectionViewCell.self,
                WOTTankPivotFixedCollectionViewCell.self,
                WOTTankPivotEmptyCollectionViewCell.self,
                WOTTankPivotDataGroupCollectionViewCell.self]
    }()

    @objc
    func registerCells() {
        WOTTankPivotViewController.registeredCells.forEach { (type) in
            let clazzStr = String(describing: type)
            let nib = UINib(nibName: clazzStr, bundle: nil)
            self.collectionView?.register(nib, forCellWithReuseIdentifier: clazzStr)
        }
    }

    private func cell(forDataNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotDataCollectionViewCell.self)
        guard let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotDataCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.symbol = node.name
        cell.dataViewColor = node.dataColor
        if let tank = node.data1 as? Tanks {
            cell.dpm = tank.dpm.suffixNumber()
            cell.mask = tank.invisibility
            cell.visibility = tank.visionRadius.suffixNumber()
        }
        return cell
    }

    private func cell(forDataGroupNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotDataGroupCollectionViewCell.self)
        guard let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as? WOTTankPivotDataGroupCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.symbol = node.name
//        cell.dataViewColor = node.dataColor
//        if let tank = node.data1 as? Tanks {
//            cell.dpm = tank.dpm.suffixNumber()
//            cell.mask = tank.invisibility
//            cell.visibility = tank.visionRadius.suffixNumber()
//        }
        return cell
    }

    private func cell(forRowNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFixedCollectionViewCell.self)
        guard let result = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as?  WOTTankPivotFixedCollectionViewCell else {
            return UICollectionViewCell()
        }
        result.textValue = node.name
        return result
    }

    private func cell(forColNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFixedCollectionViewCell.self)
        guard let result = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) as?  WOTTankPivotFixedCollectionViewCell else {
            return UICollectionViewCell()
        }
        result.textValue = node.name
        return result
    }

    private func cell(forFilterNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        let ident = String(describing: WOTTankPivotFilterCollectionViewCell.self)
        guard let result = self.collectionView?.dequeueReusableCell(withReuseIdentifier: ident, for: indexPath) else {
            return UICollectionViewCell()
        }
        return result
    }

    func cell(forNode node: WOTPivotNodeProtocol, at indexPath: IndexPath) -> UICollectionViewCell {
        switch node.cellType {
        case .column:
            return self.cell(forColNode: node, at: indexPath)
        case .row:
            return self.cell(forRowNode: node, at: indexPath)
        case .filter:
            return self.cell(forFilterNode: node, at: indexPath)
        case .data:
            return self.cell(forDataNode: node, at: indexPath)
        case .dataGroup:
            return self.cell(forDataGroupNode: node, at: indexPath)
        }

    }
}
