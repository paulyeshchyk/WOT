//
//  WOTModuleNextItemProtocol.swift
//  WOT-iOS
//
//  Created by Pavel Yeshchyk on 7/24/18.
//  Copyright © 2018 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
protocol WOTModuleNextItemProtocol {
    @objc
    func nextItem() -> Set<ModulesTree>?
}
