//
//  WOTMappingCoordinatorProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 4/24/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTMappingCoordinatorProtocol {
    @objc
    func requestSubordinate(for clazz: AnyClass, _ pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, callback: @escaping NSManagedObjectCallback)
}
