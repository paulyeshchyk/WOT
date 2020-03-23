//
//  TankPivotViewController.swift
//  WOTPivotSamples
//
//  Created by Pavel Yeshchyk on 1/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import UIKit

class TankPivotViewController: UIViewController {}

extension TankPivotViewController: UICollectionViewDelegate {}

extension TankPivotViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
