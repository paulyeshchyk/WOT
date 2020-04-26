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
    var appManager: WOTAppManagerProtocol? { get set }

    @objc
    func requestSubordinate(for clazz: AnyClass, pkCase: PKCase, subordinateRequestType: SubordinateRequestType, keyPathPrefix: String?, onCreateNSManagedObject: @escaping NSManagedObjectCallback)
}
