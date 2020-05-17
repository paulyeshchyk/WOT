//
//  DataAdapterProtocol.swift
//  WOTPivot
//
//  Created by Pavel Yeshchyk on 5/3/20.
//  Copyright © 2020 Pavel Yeshchyk. All rights reserved.
//

import Foundation

@objc
public protocol DataAdapterProtocol {

    var uuid: UUID { get }
    var onJSONDidParse: OnRequestComplete? { get set }
    func didReceiveJSON(_ json: JSON?, fromRequest: WOTRequestProtocol, _ error: Error?)
}
