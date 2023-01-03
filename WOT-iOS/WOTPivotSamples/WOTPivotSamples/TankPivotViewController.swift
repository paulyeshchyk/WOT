//
//  TankPivotViewController.swift
//  WOTPivotSamples
//
//  Created by Pavel Yeshchyk on 1/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import UIKit

// MARK: - TankPivotViewController

class TankPivotViewController: UIViewController {}

// MARK: - TankPivotViewController + UICollectionViewDelegate

extension TankPivotViewController: UICollectionViewDelegate {}

// MARK: - TankPivotViewController + UICollectionViewDataSource

extension TankPivotViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 0
    }

    func collectionView(_: UICollectionView, cellForItemAt _: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
