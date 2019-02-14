//
//  WOTModuleNextItemProtocol.swift
//  WOT-iOS
//
//  Created on 7/24/18.
//  Copyright © 2018. All rights reserved.
//

import Foundation

@objc
protocol WOTModuleNextItemProtocol {
    @objc
    func nextItem() -> Set<ModulesTree>?
}
