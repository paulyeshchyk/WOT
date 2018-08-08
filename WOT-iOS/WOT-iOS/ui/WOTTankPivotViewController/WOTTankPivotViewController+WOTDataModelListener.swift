//
//  WOTTankPivotViewController+WOTDataModelListener.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 8/6/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

extension WOTTankPivotViewController: WOTDataModelListener {

    func modelDidLoad() {
        self.collectionView.reloadData()
    }

    func modelHasNewDataItem() {

    }

    func modelDidFailLoad(error: Error) {

    }

    func metadataItems() -> [WOTNodeProtocol] {

        var result = [WOTPivotNodeProtocol]()

        let templates = WOTPivotTemplates()
        let levelTier = templates.vehicleTier.asType(.column)
        let levelType = templates.vehicleType.asType(.column)
//        let levelNati = templates.vehicleNation.asType(.column)
        let levelPrem = templates.vehicleNation.asType(.row)

        let permutator = WOTPivotMetadataPermutator()

        let cols = permutator.permutate(pivotNodes: [levelTier, levelType])
        let rows = permutator.permutate(pivotNodes: [levelPrem])
        let filt = self.pivotFilters()

        result.append(contentsOf: cols)
        result.append(contentsOf: rows)
        result.append(contentsOf: filt)
        return result
    }

    func pivotFilters () -> [WOTPivotNodeProtocol] {
        return [WOTPivotFilterNode(name: "Filter")]
    }
}
