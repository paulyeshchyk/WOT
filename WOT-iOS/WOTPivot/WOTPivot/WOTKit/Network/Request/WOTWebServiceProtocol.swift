//
//  WOTWebServiceProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol WOTWebServiceProtocol {
    var method: String { get }
    var path: String { get }
    func requestHasFinishedLoad(data: Data?, error: Error?)
}

@objc
public protocol WOTModelServiceProtocol: class {
    @objc
    static func modelClass() -> PrimaryKeypathProtocol.Type?

    @objc
    func instanceModelClass() -> AnyClass?
}
